//store_and_manage_patient_medical_records.


// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MedicalRecords {
    // Struct to store patient records
    struct Record {
        string patientName;
        string patientID;
        string diagnosis;
        string treatment;
        uint256 timestamp;
    }

    // Mapping from patient ID to their medical records
    mapping(string => Record[]) private records;

    // Address of the contract owner (e.g., hospital administrator)
    address public owner;

    // Mapping to store authorized doctors
    mapping(address => bool) public authorizedDoctors;

    // Event to log the addition of a new record
    event RecordAdded(string patientID, string diagnosis, string treatment, uint256 timestamp);

    // Modifier to restrict access to owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }

    // Modifier to restrict access to authorized doctors
    modifier onlyAuthorized() {
        require(authorizedDoctors[msg.sender] == true, "Only authorized doctors can perform this action");
        _;
    }

    // Constructor to set the owner
    constructor() {
        owner = msg.sender;
    }

    // Function to authorize a doctor
    function authorizeDoctor(address _doctor) public onlyOwner {
        authorizedDoctors[_doctor] = true;
    }

    // Function to revoke authorization of a doctor
    function revokeDoctor(address _doctor) public onlyOwner {
        authorizedDoctors[_doctor] = false;
    }

    // Function to add a new medical record
    function addRecord(string memory _patientName, string memory _patientID, string memory _diagnosis, string memory _treatment) public onlyAuthorized {
        Record memory newRecord = Record({
            patientName: _patientName,
            patientID: _patientID,
            diagnosis: _diagnosis,
            treatment: _treatment,
            timestamp: block.timestamp
        });

        records[_patientID].push(newRecord);

        emit RecordAdded(_patientID, _diagnosis, _treatment, block.timestamp);
    }

    // Function to retrieve patient records by patient ID
    function getRecords(string memory _patientID) public view returns (Record[] memory) {
        return records[_patientID];
    }
}
