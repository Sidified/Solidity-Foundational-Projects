// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

import {Voting} from "./Voting(forVending).sol";

contract Vending {
    Voting[] public listOfVotingContracts;

    function createVotingContracts(string memory _proposal) public payable {
        require(
            msg.value == 1000 wei,
            "You must pay 1000 wei to create your contract"
        );

        Voting newVotingContract = new Voting(_proposal);

        listOfVotingContracts.push(newVotingContract);
    }
}

// The contract that we are importing here [Voting(forVending).sol] is the same ‘Voting.sol’ we have created before.
// Here, instead of creating a whole new contract, we have used our previous code.
// The one modification we have done in our previous ‘Voting.sol’ contract is that we have added a ‘string memory’ variable type inside the constructor.
// We can use this while using ‘createVotingContracts’ function by passing the  ‘_proposal’ variable to store the name of the brand new contract’s instance that we have created.
