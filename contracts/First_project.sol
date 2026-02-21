// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract ENSDomen {

  struct userRegistration {
    address userAddr;
    uint userTime;
    uint userPrice;
  }

  address public owner = 0x617F2E2fD72FD9D5503197092aC168c91465E7f2;

  mapping(string => userRegistration) public listENS;

  function newRegistration(string memory _userENS) public payable {
    userRegistration memory user1 = userRegistration( msg.sender, block.timestamp, msg.value);
    listENS[_userENS] = user1;

    // address payable receiver = payable(owner);
    // (bool success, ) = receiver.call{value: msg.value}("");
    // require(success, "Transfer failed");
    payRegistration(msg.value);
  }

  function getAddress(string memory _userENS) public view returns(address){
    return listENS[_userENS].userAddr;
  }

  function payRegistration(uint _price) internal {
    address payable receiver = payable(owner);
    (bool success, ) = receiver.call{value : _price}("");
    require(success, "Transfer failed");
  }

}