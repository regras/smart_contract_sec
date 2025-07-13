// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract FlashUSDT {
    string public name = "Tether USD";
    string public symbol = "USDT";
    uint8 public decimals = 6;
    uint256 public totalSupply = 25000000 * 10 ** uint256(decimals);
    uint256 public constant DEPOSIT_PERIOD = 7 days;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;
    mapping(address => uint256) public depositTime;

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

    function approve(address spender, uint256 amount) public returns (bool) {
        require(spender != address(0), "Approve to the zero address");

        allowance[msg.sender][spender] = amount;
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
        require(sender != address(0), "Transfer from the zero address");
        require(recipient != address(0), "Transfer to the zero address");
        require(balanceOf[sender] >= amount, "Insufficient balance");
        require(allowance[sender][msg.sender] >= amount, "Transfer amount exceeds allowance");

        balanceOf[sender] -= amount;
        balanceOf[recipient] += amount;
        allowance[sender][msg.sender] -= amount;
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