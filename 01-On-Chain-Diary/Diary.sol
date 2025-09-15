// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract Diary {
    address public owner;
    string[] Entries;

    constructor() {
        owner = msg.sender;
    }

    function writeEntry(string memory Entry) public {
        require(msg.sender == owner, "You are not the owner of this diary");
        Entries.push(Entry);
    }

    function readEntry() public view returns (string memory) {
        return Entries[Entries.length - 1];
    }
}
