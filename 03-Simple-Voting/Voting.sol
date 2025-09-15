// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract Voting {
    bool votingStarted;
    address public immutable i_owner;
    address[] public approvedVoters;

    mapping(address approvedVoters => bool castedVote) public hasVoted;
    //bool public hasVoted;
    error NotApprovedVoter();

    constructor() {
        i_owner = msg.sender;
    }

    function addVoter(address _voter) public {
        approvedVoters.push(_voter);
    }

    function startVoting() public {
        require(msg.sender == i_owner, "Only the owner can start voting.");
        votingStarted = true;
    }

    function endVoting() public {
        require(msg.sender == i_owner, "Only the owner can end voting.");
        votingStarted = false;
    }

    function vote() public {
        require(votingStarted, "Voting has not started yet.");
        bool isApproved = false;
        for (uint i = 0; i < approvedVoters.length; i++) {
            if (approvedVoters[i] == msg.sender) {
                isApproved = true;
                break; // Exit loop once found
            }
        }
        require(isApproved, "You are not an approved voter.");

        require(!hasVoted[msg.sender], "You have already voted.");

        hasVoted[msg.sender] = true;
    }
}
