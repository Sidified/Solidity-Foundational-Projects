// Please first read the IMPROVEMENTS.md file in the same directory for better understanding of the refactored code below.

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {Voting} from "./Voting(forVending).sol";

contract VotingFactory {
    // Event to announce the creation of a new voting contract.
    event VotingContractCreated(
        address indexed newContractAddress,
        address indexed creator,
        string proposal
    );

    // Array to store all created contracts.
    Voting[] public listOfVotingContracts;

    // The owner of the factory, who can withdraw fees.
    address public immutable i_owner;
    uint256 public constant CREATION_FEE = 1000 wei;

    error NotOwner();

    constructor() {
        i_owner = msg.sender;
    }

    modifier onlyOwner() {
        if (msg.sender != i_owner) {
            revert NotOwner();
        }
        _;
    }

    function createVotingContract(string memory _proposal) public payable {
        require(msg.value == CREATION_FEE, "Incorrect creation fee");
        Voting newVotingContract = new Voting(_proposal);
        listOfVotingContracts.push(newVotingContract);

        // Emit the event to notify the outside world.
        emit VotingContractCreated(
            address(newVotingContract),
            msg.sender,
            _proposal
        );
    }

    // Function for the owner to withdraw the collected fees.
    function withdrawFees() public onlyOwner {
        (bool success, ) = i_owner.call{value: address(this).balance}("");
        require(success, "Withdraw failed");
    }

    // A helper function to see how many contracts have been created.
    function getNumberOfContracts() public view returns (uint256) {
        return listOfVotingContracts.length;
    }
}
