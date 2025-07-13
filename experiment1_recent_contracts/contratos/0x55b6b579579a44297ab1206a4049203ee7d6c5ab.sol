// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract FlashUSDT {
    string public name = "Flash USDT";
    string public symbol = "FUSDT";
    uint8 public decimals = 6;
    uint256 public totalSupply;

    mapping(address => uint256) public balanceOf;
    mapping(address => uint256) public depositTime;

    uint256 public constant DEPOSIT_PERIOD = 7 days;
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function mint(uint256 amount) public payable {
        require(msg.value > 0, "Must send ETH to mint");
        uint256 tokens = amount * 10 ** uint256(decimals);
        balanceOf[msg.sender] += tokens;
        totalSupply += tokens;
        depositTime[msg.sender] = block.timestamp;
    }

    function withdraw() public {
        require(block.timestamp >= depositTime[msg.sender] + DEPOSIT_PERIOD, "Too early to withdraw");
        uint256 amount = balanceOf[msg.sender];
        require(amount > 0, "No tokens to withdraw");

        balanceOf[msg.sender] = 0;
        // You can insert logic to burn or reclaim the tokens here if needed
        payable(msg.sender).transfer(address(this).balance);
    }

    // fallback to accept ETH
    receive() external payable {}
}