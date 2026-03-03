// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/access/Ownable.sol";
error NotAllowed();

interface CheckType {
    function getRecordType() external pure returns(string memory);
}

contract StringRecord {
    uint public immutable timeOfCreation;
    string public record;

    constructor(uint _time) {
        timeOfCreation = _time;
    }

    function getRecordType() external pure returns(string memory){
        return "string";
    }

    function setRecord(string calldata _record) public {
        record = _record;
    }
}

contract StringFactory {
    address public storageOfRecords;

    constructor(address _addr) {
        storageOfRecords = _addr;
    }

    function addRecord(string calldata _str) public {
        StringRecord record = new StringRecord(block.timestamp);
        record.setRecord(_str);
        RecordsStorage(storageOfRecords).addRecord(address(record));
    }

    function getAddress() public view returns(address) {
        return address(this);
    }
}

contract AddressRecord {
    uint public immutable timeOfCreation;
    address public record;

    constructor(uint _time) {
        timeOfCreation = _time;
    }

    function getRecordType() external pure returns(string memory){
        return "address";
    }

    function setRecord(address _addr) public {
        record = _addr;
    } 
}

contract AddressFactory {
    address public storageOfRecords;

    constructor(address _addr) {
        storageOfRecords = _addr;
    }

    function addRecord(address _addr) public {
        AddressRecord record = new AddressRecord(block.timestamp);
        record.setRecord(_addr);
        RecordsStorage(storageOfRecords).addRecord(address(record));
    }

    function getAddress() public view returns(address) {
        return address(this);
    }
}

contract EnsRecord {
    uint public immutable timeOfCreation;
    string public domain;
    address public owner;

    constructor(uint _time) {
        timeOfCreation = _time;
    }

    function getRecordType() external pure returns(string memory){
        return "ens";
    }

    function setOwner(address _addr) public {
        owner = _addr;
    }

    function setDomain(string calldata _ens) public {
        domain = _ens;
    }
}

contract EnsFactory {
    address public storageOfRecords;

    constructor(address _addr) {
        storageOfRecords = _addr;
    }

    function addRecord(address _addr, string calldata _domain) public {
        EnsRecord record = new EnsRecord(block.timestamp);
        record.setOwner(_addr);
        record.setDomain(_domain);
        RecordsStorage(storageOfRecords).addRecord(address(record));
    }

    function getAddress() public view returns(address) {
        return address(this);
    }
}

contract RecordsStorage is Ownable {
    address[] public records;
    mapping(address => bool) isRecord;
    mapping(address => bool) public factories;

    modifier onlyFactory(address _addr) {
        require(factories[_addr], NotAllowed());
        _;
    }

    constructor() Ownable(msg.sender) {
    }

    function addFactory(address _addr) external onlyOwner {
        factories[_addr] = true;
    }

    function addRecord(address _addr) external onlyFactory(msg.sender) {
        records.push(_addr);
        isRecord[_addr] = true;
    }

    function getAddress() public view returns(address) {
        return address(this);
    }
}

contract ViewerStorage is RecordsStorage {

    function getType(address _addr) external view returns(string memory) {
        require(isRecord[_addr], "Incorrect address");
        return CheckType(_addr).getRecordType();
    }

    function getString(address _addr) external view returns(uint, string memory) {
        return (StringRecord(_addr).timeOfCreation(), StringRecord(_addr).record());
    }

    function getAddress(address _addr) external view returns(uint, address) {
        return (AddressRecord(_addr).timeOfCreation(), AddressRecord(_addr).record());
    }

    function getEns(address _addr) external view returns(uint, string memory, address) {
        return (EnsRecord(_addr).timeOfCreation(), EnsRecord(_addr).domain(), EnsRecord(_addr).owner());
    }

}