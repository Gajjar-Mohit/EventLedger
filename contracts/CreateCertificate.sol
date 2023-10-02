// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

contract CreateCertificate {
    struct Certificate {
        string participentName;
        string cid;
        string wonPriceFor;
        string eventName;
        string eventDate;
    }
    struct Event {
        string eventName;
        address eventOwner;
        string date;
        string[] certificates;
    }

    mapping(address => Event) events;

    function registerEvent(
        string memory eventName,
        string memory date,
        address eventAdd
    ) public {
        events[eventAdd].eventName = eventName;
        events[eventAdd].date = date;
        events[eventAdd].eventOwner = eventAdd;
    }

    function getAllEvents()
        public
        view
        returns (
            string memory eventName,
            address eventOwner,
            string memory date,
            string[] memory certificates
        )
    {
        Event storage event_ = events[msg.sender];
        return (
            event_.eventName,
            event_.eventOwner,
            event_.date,
            event_.certificates
        );
    }

    function getEvent(
        address eventAddress
    ) public view returns (string memory eventName, string memory eventDate) {
        Event storage event_ = events[eventAddress];
        return (event_.eventName, event_.date);
    }

    function generateCertificate(string memory cid) public returns (bool) {
        Event storage event_ = events[msg.sender];
        event_.certificates.push(cid);
        return true;
    }

    function verifyCertificate(
        address eventAddress,
        string memory cid
    ) public view returns (string memory cid_) {
        Event storage event_ = events[eventAddress];

        string[] storage cids = event_.certificates;

        for (uint i = 0; i < cids.length; i++) {
            if (keccak256(bytes(cids[i])) == keccak256(bytes(cid))) {
                return (cids[i]);
            }
        }

        return ("");
    }
}
