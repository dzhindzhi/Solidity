// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./SharedWallet.sol";

contract Wallet is SharedWallet{

    event MoneyWithdrawn(address indexed _to, uint _amount);
    event Moneyreceived(address indexed _from, uint _amount);

    function getBalance() public view returns(uint) {
        return address(this).balance;
    }

    function withdrawMoney(uint _amount) external ownerOrWithinLimits(_amount) {
        require(_amount <= getBalance(), "Not enough money");
        if(!isOwner()) { deduceFromLimit(msg.sender, _amount); }
        (bool success, ) = payable(msg.sender).call{value : _amount}("");
        require(success, "Error of withdraw");
        emit MoneyWithdrawn(msg.sender, _amount);
    } 

    fallback() external payable { }
    receive() external payable { 
        emit Moneyreceived(msg.sender, msg.value);
    }
}