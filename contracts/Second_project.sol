// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract ENSDomen {

  struct userRegistration {
    address userAddr;
    uint userTime;
    uint userPrice;
    uint amountYears;
  }

  address public owner;
  uint public pricePerYear;
  uint public ratioUpdate;
  mapping(string => userRegistration) public listENS;

  constructor() {
    owner = msg.sender;
    pricePerYear = 0.1 ether;
    ratioUpdate = 1;
  }

  receive() external payable {}

  fallback() external payable {}

  modifier onlyOwner(address _addr) {
    require(_addr == owner, "Good try");
    _;
  }

  modifier checkYears(uint _amount) {
    require(_amount >= 1 && _amount <= 10, "Uncorect amount of years");
    _;
  }

  modifier checkValue(uint _amount, uint _receiveAmount) {
    require(_receiveAmount >= _amount * pricePerYear, "Not enough money");
    _;
  }

  function setPricePerYear(uint _price) public onlyOwner(msg.sender) {
    require(_price > 0, "Check input data");
    pricePerYear = _price;
  }

  function setUpdateRatio(uint _ratio) public onlyOwner(msg.sender) {
    require(_ratio > 0, "Check input data");
    ratioUpdate = _ratio;
  }

  function newRegistration(string memory _userENS, uint _amountYears) public payable 
  checkYears(_amountYears) 
  checkValue(_amountYears, msg.value) { 
    require(listENS[_userENS].userAddr == address(0) || listENS[_userENS].userTime + listENS[_userENS].amountYears * 365 days < block.timestamp, "ENSDomen is not available" );
    userRegistration memory user1 = userRegistration( msg.sender, block.timestamp, _amountYears*pricePerYear, _amountYears);
    listENS[_userENS] = user1;
    if (msg.value > _amountYears * pricePerYear) {
        (bool success, ) = payable(msg.sender).call{value : msg.value - _amountYears * pricePerYear}("");
        require(success, "Error of refund");
    }
    //payRegistration(_amountYears*pricePerYear);
  }

  function updateRegistration(string memory _userENS, uint _amountYears) public payable 
  checkYears(_amountYears) 
  checkValue(_amountYears*ratioUpdate, msg.value) {
    require(msg.sender == listENS[_userENS].userAddr, "You can't add years for this ENSDomen");
    listENS[_userENS].amountYears += _amountYears;
    if (msg.value > _amountYears * pricePerYear * ratioUpdate) {
        (bool success, ) = payable(msg.sender).call{value : msg.value - _amountYears * pricePerYear * ratioUpdate}("");
        require(success, "Error of refund");
    }
    //payRegistration(_amountYears*pricePerYear*ratioUpdate);

  }

  function getAddress(string memory _userENS) public view returns(address){
    return listENS[_userENS].userAddr;
  }

  function payRegistration(uint _price) internal {
    address payable receiver = payable(owner);
    (bool success, ) = receiver.call{value : _price}("");
    require(success, "Transfer failed");
  }

  function getBalance() public view returns(uint){
    return address(this).balance;
  }

}