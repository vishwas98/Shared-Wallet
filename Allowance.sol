//SPDX-License-Identifier: MIT

pragma solidity 0.8.1;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

contract Allowance is Ownable {

    event AllowanceChanged(address indexed _forWho, address indexed _byWhom, uint _oldAmount, uint _newAmount);
    mapping(address => uint) public allowance;

    function isOwner() internal view returns(bool) {
        return owner() == msg.sender;
    }

    function setAllowance( address _userAddress, uint _amountToBeAllowed) public onlyOwner {
        emit AllowanceChanged(_userAddress, msg.sender, allowance[_userAddress], _amountToBeAllowed);
        allowance[_userAddress] = _amountToBeAllowed;
    }

    modifier ownerPlusAllowed(uint _amountToBeAllowed) {
        require(isOwner() || allowance[msg.sender] >= _amountToBeAllowed, "You are not allowed!");
        _;
    }

    function reduceAllowance(address _userAddress, uint _amountToBeAllowed) internal ownerPlusAllowed(_amountToBeAllowed) {
        emit AllowanceChanged(_userAddress, msg.sender, allowance[_userAddress], allowance[_userAddress] - _amountToBeAllowed);
        allowance[_userAddress] -= _amountToBeAllowed;
    }

}

