// SPDX-License-Identifier:MIT
pragma solidity ^0.8.17;

contract Escrow {
    bool public buyerWantTheOrder;
    bool public putTheOrder;
    address public immutable i_owner;
    address public buyer;
    address public seller;
    bool public orderReceived;

    constructor() {
        i_owner = msg.sender;
    }

    function placeOrder_byBuyer() public payable {
        require(
            msg.sender != i_owner,
            "You are the Escrow, you cannot be the buyer"
        );
        if (msg.value != 100 wei) {
            revert("You need to pay 100 Wei");
        }
        buyerWantTheOrder = true;
        buyer = msg.sender;
    }

    function middleMan_stepOne() public {
        require(
            buyerWantTheOrder == true,
            "Buyer has not placed the order yet."
        );
        require(msg.sender == i_owner, "You are not the owner");
        putTheOrder = true;
    }

    function receiveOrder_bySeller() public {
        require(
            msg.sender != i_owner,
            "You are the Escrow, you cannot be the seller"
        );
        require(
            msg.sender != buyer,
            "You are the buyer, you cannot be the seller"
        );
        require(putTheOrder == true, "The Escrow has not put the order yet.");
        seller = msg.sender;
        orderReceived = true;
    }

    function middleMan_stepTwo() public payable {
        require(msg.sender == i_owner, "You are not the owner");
        require(
            orderReceived == true,
            "Seller has not received the order yet."
        );
        require(msg.value == 100 wei, "You need to pay 100 Wei");
        (bool callSuccess, ) = payable(seller).call{
            value: address(this).balance
        }("");
        if (!callSuccess) sendBack();
        require(callSuccess, "Call Failed!");
        buyerWantTheOrder = false;
        putTheOrder = false;
        orderReceived = false;
    }

    function sendBack() internal {
        (bool sentBackToBuyer, ) = payable(buyer).call{
            value: address(this).balance
        }("");
        require(sentBackToBuyer, "Failed to send back to buyer");
    }
}
