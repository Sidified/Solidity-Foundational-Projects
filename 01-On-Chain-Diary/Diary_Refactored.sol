// Please first read the IMPROVEMENTS.md file in the same directory for better understanding of the refactored code below.

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract Diary {
    // Made owner immutable for gas savings.
    address public immutable i_owner;

    // Renamed for clarity, following a common convention.
    string[] private s_entries;

    // A custom error is even more gas-efficient than a require string.
    error NotOwner();

    constructor() {
        i_owner = msg.sender;
    }

    // A modifier makes the access control cleaner and reusable.
    modifier onlyOwner() {
        if (msg.sender != i_owner) {
            revert NotOwner();
        }
        _;
    }

    function writeEntry(string memory newEntry) public onlyOwner {
        s_entries.push(newEntry);
    }

    function readLastEntry() public view returns (string memory) {
        // Added a check to prevent an error on an empty array.
        require(s_entries.length > 0, "Diary is empty.");
        return s_entries[s_entries.length - 1];
    }

    // It's good practice to also have a way to read all entries
    // or a specific entry by index.
    function readEntryAtIndex(
        uint256 index
    ) public view returns (string memory) {
        return s_entries[index];
    }

    function getNumberOfEntries() public view returns (uint256) {
        return s_entries.length;
    }
}
