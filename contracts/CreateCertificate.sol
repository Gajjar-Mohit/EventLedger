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
        Certificate[] certificates;
    }

    mapping(address => Event) events;

    function registerEvent(string memory eventName, string memory date) public {
        Event storage event_ = events[msg.sender];
        event_.date = date;
        event_.eventName = eventName;
        event_.eventOwner = msg.sender;
    }

    function getAllEvents()
        public
        view
        returns (
            string memory eventName,
            address eventOwner,
            string memory date,
            Certificate[] memory certificates
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

    function generateCertificate(
        string memory participentName,
        string memory cid,
        string memory wonPriceFor,
        string memory eventName,
        string memory eventDate
    ) public returns (bool) {
        Event storage event_ = events[msg.sender];
        event_.certificates.push(
            Certificate(participentName, cid, wonPriceFor, eventName, eventDate)
        );
        return true;
    }

    function verifyCertificate(
        address eventAddress,
        string memory cid
    )
        public
        view
        returns (
            string memory participentName,
            string memory cid_,
            string memory wonPriceFor,
            string memory eventName,
            string memory eventDate
        )
    {
        Event storage event_ = events[eventAddress];
        Certificate[] storage certificates = event_.certificates;

        for (uint i = 0; i < certificates.length; i++) {
            if (
                keccak256(bytes(certificates[i].cid)) == keccak256(bytes(cid))
            ) {
                return (
                    certificates[i].participentName,
                    certificates[i].cid,
                    certificates[i].wonPriceFor,
                    event_.eventName,
                    event_.date
                );
            }
        }

        return ("", "", "", "", "");
    }
}
