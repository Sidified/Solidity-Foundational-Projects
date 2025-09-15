
# Smart Contract Optimizations: Ticket Sale Contract 🎟️

This document outlines key optimizations for our `Tickets.sol` smart contract, focusing on improving gas efficiency and code robustness.

---

## 1. 🔍 Efficient Buyer Checks: From Array to Mapping

Your current method of checking if a sender is already a buyer is a major source of inefficiency.

#### The Problem
The `for` loop iterates through the entire `Buyers` array every time someone tries to buy a ticket. As the number of buyers grows, this function becomes extremely expensive in terms of gas. Eventually, the transaction cost could become so high that it fails entirely.

#### The Solution
A **`mapping`** is the perfect tool for this. A lookup in a mapping is incredibly efficient and costs a very low, constant amount of gas, whether you have 1 buyer or 1 million buyers.

### Original Code
```solidity
function senderIsNotBuyer() internal view returns (bool) {
    for (uint256 i = 0; i < Buyers.length; i++) {
        if (Buyers[i] == msg.sender) {
            return false;
        }
    }
    return true;
}
````

### ✨ Improved Code

Instead of the `Buyers` array and the loop, you use a mapping to track who has bought a ticket.

```solidity
// Replace 'address[] public Buyers;' with this mapping:
mapping(address => bool) public hasBoughtTicket;

// Inside the buyTicket() function, replace the require statement:
function buyTicket() public payable {
    require(!hasBoughtTicket[msg.sender], "You have already bought a ticket");
    // ... rest of the function ...
    hasBoughtTicket[msg.sender] = true; // Mark them as a buyer
}
```

>   - `!hasBoughtTicket[msg.sender]`: This is much cleaner and more efficient. It directly checks the mapping. The `!` means "not," so it checks if `hasBoughtTicket` for the sender is `false`.
>   - `hasBoughtTicket[msg.sender] = true;`: After a successful purchase, you simply flip their status to `true`.

-----

## 2\. 💰 Robust Price Handling: Using `constant`

Your current method for checking the ticket price works, but it can be made more robust and gas-efficient.

#### The Problem

Using `if/revert` is slightly more verbose than using `require`. Also, **hardcoding** the price `100 wei` directly in the function makes the contract harder to read and maintain.

#### The Solution

Store the ticket price in a **`constant`** variable for better gas efficiency and readability, and use a `require` statement for the check.

### Original Code

```solidity
if (msg.value != 100 wei) {
    revert("You need to pay 100 Wei");
}
```

### ✨ Improved Code

```solidity
// At the top of your contract, with your other state variables:
uint256 public constant TICKET_PRICE = 100 wei;

// Inside the buyTicket() function:
function buyTicket() public payable {
    // ... other require statements ...
    require(msg.value == TICKET_PRICE, "Please send exactly 100 wei");
    // ... rest of the function ...
}
```

> Using **`constant`** makes reading the variable much cheaper on gas because the value is baked directly into the contract's bytecode at compile time.

-----

## 3\. 💾 State Variable Optimization: Reducing Storage Costs

You can make your state variables more gas-efficient by reducing unnecessary storage operations.

#### The Problem

Every time you read from or write to state variables like `totalTickets` or `totalMoneyCollected`, it costs a significant amount of gas because it's a **storage operation** (SSTORE/SLOAD), which is one of the most expensive operations on the EVM.

#### The Solution

Since you have a fixed `TICKET_PRICE` and a fixed initial number of tickets, `totalMoneyCollected` is not actually needed. The owner can always calculate the total funds by checking the contract's balance or by multiplying `TICKET_PRICE` by the number of tickets sold. This saves gas on every `buyTicket` call because you no longer need to update this variable.

### Original Code

```solidity
uint256 public totalTickets = 10;
uint256 public totalMoneyCollected;
```

### ✨ Improved Code

```solidity
uint256 public constant INITIAL_TICKETS = 10;
uint256 public constant TICKET_PRICE = 100 wei;

// We can rename totalTickets to ticketsRemaining for clarity.
uint256 public ticketsRemaining = INITIAL_TICKETS;

// We remove 'totalMoneyCollected' entirely.
```
