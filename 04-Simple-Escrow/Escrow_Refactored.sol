// Please first read the IMPROVEMENTS.md file in the same directory for better understanding of the refactored code below.

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract Escrow {
    // Roles are set at the beginning and can't be changed.
    address public immutable i_depositor; // The person sending the money (Buyer)
    address public immutable i_beneficiary; // The person receiving the money (Seller)
    address public immutable i_arbiter; // The person who decides (Judge)

    uint256 public dealAmount;
    bool public isPaid;

    error NotAuthorized();
    error AlreadyPaid();

    // The constructor sets up the entire deal at once.
    constructor(
        address _beneficiary,
        address _arbiter,
        uint256 _dealAmount
    ) payable {
        i_depositor = msg.sender;
        i_beneficiary = _beneficiary;
        i_arbiter = _arbiter;
        dealAmount = _dealAmount;

        // The buyer can optionally deposit the funds when creating the contract.
        if (msg.value > 0) {
            require(msg.value == dealAmount, "Incorrect deposit amount");
        }
    }

    // A simple modifier to ensure only the arbiter can call a function.
    modifier onlyArbiter() {
        if (msg.sender != i_arbiter) {
            revert NotAuthorized();
        }
        _;
    }

    // The depositor can call this function to send the funds.
    function deposit() public payable {
        require(
            msg.sender == i_depositor,
            "Only the depositor can deposit funds"
        );
        require(msg.value == dealAmount, "Must deposit the exact deal amount");
        require(!isPaid, "Funds have already been paid out");
    }

    // The arbiter calls this to release funds to the beneficiary (Seller).
    function releaseFunds() public onlyArbiter {
        require(!isPaid, "Funds have already been paid out");

        // CHECKS-EFFECTS-INTERACTIONS PATTERN:
        // 1. Checks are done (in the modifier and the require statement above).

        // 2. Effects (Update the state BEFORE sending money).
        isPaid = true;

        // 3. Interactions (Send the money LAST).
        (bool success, ) = i_beneficiary.call{value: address(this).balance}("");
        require(success, "Failed to release funds");
    }

    // The arbiter calls this to refund funds to the depositor (Buyer).
    function refundFunds() public onlyArbiter {
        require(!isPaid, "Funds have already been paid out");

        // CHECKS-EFFECTS-INTERACTIONS PATTERN:
        // 1. Checks are done.

        // 2. Effects.
        isPaid = true;

        // 3. Interactions.
        (bool success, ) = i_depositor.call{value: address(this).balance}("");
        require(success, "Failed to refund funds");
    }
}
