// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract PublicJournal {
    struct Entry {
        address author;
        string message;
        uint timestamp;
        uint likes;  // new feature
    }

    Entry[] public entries;

    event NewEntry(address indexed author, string message, uint timestamp);
    event EntryEdited(uint indexed entryId, string newMessage, uint timestamp);
    event EntryLiked(uint indexed entryId, address indexed liker, uint totalLikes);

    // Write new journal entry
    function writeEntry(string memory _message) public {
        Entry memory newEntry = Entry(msg.sender, _message, block.timestamp, 0);
        entries.push(newEntry);
        emit NewEntry(msg.sender, _message, block.timestamp);
    }

    // Edit your own entry
    function editEntry(uint _id, string memory _newMessage) public {
        require(_id < entries.length, "Entry does not exist");
        require(entries[_id].author == msg.sender, "You can only edit your own entry");

        entries[_id].message = _newMessage;
        entries[_id].timestamp = block.timestamp; // update time
        emit EntryEdited(_id, _newMessage, block.timestamp);
    }

    // Like an entry
    function likeEntry(uint _id) public {
        require(_id < entries.length, "Entry does not exist");

        entries[_id].likes += 1;
        emit EntryLiked(_id, msg.sender, entries[_id].likes);
    }

    // Get a single entry by ID
    function getEntry(uint _id) public view returns (Entry memory) {
        require(_id < entries.length, "Entry does not exist");
        return entries[_id];
    }

    // Get all entries
    function getAllEntries() public view returns (Entry[] memory) {
        return entries;
    }

    // Get entries by author
    function getEntriesByAuthor(address _author) public view returns (Entry[] memory) {
        uint count = 0;
        for (uint i = 0; i < entries.length; i++) {
            if (entries[i].author == _author) {
                count++;
            }
        }

        Entry[] memory result = new Entry[](count);
        uint j = 0;
        for (uint i = 0; i < entries.length; i++) {
            if (entries[i].author == _author) {
                result[j] = entries[i];
                j++;
            }
        }
        return result;
    }

    // Get number of entries
    function getEntriesCount() public view returns (uint) {
        return entries.length;
    }
}
