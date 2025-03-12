// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VulnerableDAO {
    mapping(address => uint256) public balances;

    event Deposit(address indexed user, uint256 amount);
    event Withdrawal(address indexed user, uint256 amount);

    function deposit() external payable {
        require(msg.value > 0, "Must deposit some Ether");
        balances[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw() external {
        uint256 userBalance = balances[msg.sender];
        require(userBalance > 0, "No funds to withdraw");

        (bool success, ) = msg.sender.call{value: userBalance}("");
        require(success, "Failed to send Ether");
        balances[msg.sender] = 0;

        emit Withdrawal(msg.sender, userBalance);
    }

    function getContractBalance() external view returns (uint256) {
        return address(this).balance;
    }
}