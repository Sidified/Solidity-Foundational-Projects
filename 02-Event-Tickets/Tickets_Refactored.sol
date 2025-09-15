// Please first read the IMPROVEMENTS.md file in the same directory for better understanding of the refactored code below.

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract Tickets {
    // State variables are now constants for gas savings.
    uint256 public constant INITIAL_TICKETS = 10;
    uint256 public constant TICKET_PRICE = 100 wei;
    address public immutable i_owner;

    // A mapping is much more efficient than an array for lookups.
    mapping(address => bool) public hasBoughtTicket;
    uint256 public ticketsRemaining = INITIAL_TICKETS;

    error NotOwner();

    constructor() {
        i_owner = msg.sender;
    }

    function buyTicket() public payable {
        // All checks are now clean 'require' statements at the top.
        require(ticketsRemaining > 0, "No more tickets available!");
        require(
            !hasBoughtTicket[msg.sender],
            "You have already bought a ticket"
        );
        require(msg.value == TICKET_PRICE, "Please send exactly 100 wei");

        ticketsRemaining--; // A more compact way to write ticketsRemaining = ticketsRemaining - 1
        hasBoughtTicket[msg.sender] = true;
    }

    function withdrawFund() public onlyOwner {
        // Since we are no longer storing the buyers list,
        // there is no need to reset an array.

        // The contract balance is implicitly the money collected.
        (bool callSuccess, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(callSuccess, "Withdrawing Failed!");
    }

    modifier onlyOwner() {
        if (msg.sender != i_owner) {
            revert NotOwner();
        }
        _;
    }
}
