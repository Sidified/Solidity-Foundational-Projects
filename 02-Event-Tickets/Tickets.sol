// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract Tickets {
    uint256 public totalTickets = 10;
    address public immutable i_owner;
    address[] public Buyers;
    uint256 public totalMoneyCollected;
    error NotOwner();

    constructor() {
        i_owner = msg.sender;
    }

    function senderIsNotBuyer() internal view returns (bool) {
        for (uint256 i = 0; i < Buyers.length; i++) {
            if (Buyers[i] == msg.sender) {
                return false; // Found them, so they are a buyer.
            }
        }
        return true; // Did not find them, they are not a buyer.
    }

    function buyTicket() public payable {
        require(senderIsNotBuyer(), "You have already bought a ticket");
        require(totalTickets > 0, "No more tickets Available!");

        if (msg.value != 100 wei) {
            revert("You need to pay 100 Wei");
        }
        totalTickets -= 1;
        Buyers.push(msg.sender);
        totalMoneyCollected += msg.value;
    }

    function withdrawFund() public onlyOwner {
        Buyers = new address[](0);
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
