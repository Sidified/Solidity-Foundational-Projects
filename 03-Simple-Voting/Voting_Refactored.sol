// Please first read the IMPROVEMENTS.md file in the same directory for better understanding of the refactored code below.

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract Voting {
    // State Variables
    address public immutable i_owner;
    string public proposalDescription;
    bool public votingStarted;
    uint256 public votesFor;
    uint256 public votesAgainst;

    // Mappings are used for efficient lookups.
    mapping(address => bool) public isApprovedVoter;
    mapping(address => bool) public hasVoted;

    // Custom error for access control.
    error NotOwner();

    constructor(string memory _proposal) {
        i_owner = msg.sender;
        proposalDescription = _proposal;
    }

    // Modifier for reusable access control.
    modifier onlyOwner() {
        if (msg.sender != i_owner) {
            revert NotOwner();
        }
        _;
    }

    // Admin Functions
    function addVoter(address _voter) public onlyOwner {
        isApprovedVoter[_voter] = true;
    }

    function startVoting() public onlyOwner {
        votingStarted = true;
    }

    function endVoting() public onlyOwner {
        votingStarted = false;
    }
}
