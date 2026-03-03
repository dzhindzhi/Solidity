// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract StringRecord {
    uint public immutable timeOfCreation;
    string public record;

    constructor(uint _time) {
        timeOfCreation = _time;
    }

    function getRecordType() public pure returns(string memory){
        return "string";
    }

    function setRecord(string memory _record) public {
        record = _record;
    }

}

contract AddressRecord {
    uint public immutable timeOfCreation;
    address public record;

    constructor(uint _time) {
        timeOfCreation = _time;
    }

    function getRecordType() public pure returns(string memory){
        return "address";
    }

    function setRecord(address _addr) public {
        record = _addr;
    }
    
}

contract RecordFactory {
    AddressRecord[] public recordOfAddress;
    StringRecord[] public recordOfString;

    function addRecord(string memory _str) public {
        StringRecord record = new StringRecord(block.timestamp);
        record.setRecord(_str);
        recordOfString.push(record);
    }

    function addRecord(address _addr) public {
        AddressRecord record = new AddressRecord(block.timestamp);
        record.setRecord(_addr);
        recordOfAddress.push(record);
    }
}