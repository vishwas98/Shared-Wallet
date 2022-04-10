//SPDX-License-Identifier: MIT

pragma solidity 0.8.1;
import "./Allowance.sol";
contract SharedWallet is Allowance {
    event MoneySentOverContract(address indexed _beneficiary, uint _amount);
    event MoneyReceivedOverContract(address indexed _from, uint _amount);
    function MoneyWithdrawal(address payable _recipient, uint _amount) public ownerPlusAllowed(_amount) {
        require(_amount <= address(this).balance, "Contract does not have sufficient funds. Please add funds to the contract.");
        if(!isOwner()) {
            reduceAllowance(msg.sender, _amount);
        }
        emit MoneySentOverContract(_recipient, _amount);
        _recipient.transfer(_amount);

    }

    function renounceOwnership() public view override onlyOwner {
        revert("Cannot renounceOwnership here"); //not possible with this smart contract
    }
    receive() external payable {
        emit MoneyReceivedOverContract(msg.sender, msg.value);
    }
}
