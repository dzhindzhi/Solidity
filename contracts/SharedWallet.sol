// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/access/Ownable.sol";


contract SharedWallet is Ownable {

    event LimitChanged(address indexed _member, uint _oldLimit, uint _newLimit);

    struct Member {
        string name;
        uint balance;
        bool isAdmin;
    }

    mapping(address => Member) public members;

    constructor() Ownable(msg.sender) {
  
    }

    modifier ownerOrWithinLimits(uint _amount) {
        require(isOwner() || members[msg.sender].balance >= _amount, "Not allowed!");
        _;
    }

    function isOwner() internal view returns(bool) {
        return msg.sender == owner() || members[msg.sender].isAdmin;
    }

    function addLimit(address _member, string calldata _name, uint _limit) external {
        members[_member] = Member(_name, _limit, false);
    }

    function deleteLimit(address _member) external onlyOwner {
        delete members[_member];
    }

    function deduceFromLimit(address _member, uint _amount) internal {
        members[_member].balance -= _amount;
        emit LimitChanged(_member, members[_member].balance +_amount, members[_member].balance);
    }

    function makeAdmin(address _admin) external onlyOwner {
        members[_admin].isAdmin = true;
    }

    function revokeAdmin(address _admin) external onlyOwner {
        members[_admin].isAdmin = false;
    }

    function renounceOwnership() public view override onlyOwner{
        revert("CAn't renounce");
    }
}