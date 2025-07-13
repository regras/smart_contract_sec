// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Hurricane {
    struct Deposit {
        address depositor;
        uint256 amount;
        bool withdrawn;
    }

    struct Referral {
        address referralAddress;
        uint256 amount;
    }

    address public owner;
    mapping(string => Deposit) public deposits;
    mapping(address => Referral) public referrals;
    uint256 public feeAmount = 0.003 ether;
    uint256 public feeAmount1 = 0.006 ether;
    uint256 public feeAmount2 = 0.015 ether;
    uint256 public feeAmount3 = 0.03 ether;
    uint256 public referralAmount = 0.0005 ether;
    uint256 public referralAmount1 = 0.001 ether;
    uint256 public referralAmount2 = 0.001 ether;
    uint256 public referralAmount3 = 0.001 ether;

    event Deposited(address indexed depositor, uint256 amount, string note);
    event Withdrawn(address indexed depositor, uint256 amount, address to, string note);
    event OwnerWithdrawn(address indexed owner, uint256 amount);
    event ReferralBonusAmountUpdated(uint256 newAmount);
    event FeeAmountUpdated(uint256 newFeeAmount);
    event ReferralAmountUpdated(uint256 newFeeAmount);
    event ReferralBonusAdded(address indexed referrer, uint256 amount);
    event ReferralCreated(address indexed referrer, uint256 amount);
    event Withdrawal(address indexed beneficiary, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function deposit(string memory _note, uint256 tier) external payable {
        require(deposits[_note].depositor == address(0), "Note already used"); // Ensure uniqueness

        uint256 fee;

        if (tier == 0) {
            fee = feeAmount;
        } else if (tier == 1) {
            fee = feeAmount1;
        } else if (tier == 2) {
            fee = feeAmount2;
        } else if (tier == 3) {
            fee = feeAmount3;
        } else {
            revert("Invalid tier");
        }

        uint256 netAmount = msg.value - fee;
        require(netAmount > 0, "Deposit amount must be greater than the fee");

        deposits[_note] = Deposit(msg.sender, netAmount, false);
        emit Deposited(msg.sender, netAmount, _note);
    }

    function depositWithReferral(string memory _note, address referralAddress, uint256 tier) external payable {
        require(deposits[_note].depositor == address(0), "Note already used"); // Ensure uniqueness

        uint256 fee;
        uint256 referral;

        if (tier == 0) {
            // 0.003
            fee = feeAmount;
            referral = referralAmount;
        } else if (tier == 1) {
            fee = feeAmount1;
            // 0.006
            referral = referralAmount1;
        } else if (tier == 2) {
            // 0.015
            fee = feeAmount2;
            referral = referralAmount2;
        } else if (tier == 3) {
            // 0.03
            fee = feeAmount3;
            referral = referralAmount3;
        } else {
            revert("Invalid tier");
        }

        uint256 netAmount = msg.value - fee - referral;
        require(netAmount > 0, "Deposit amount must be greater than the fee");

        deposits[_note] = Deposit(msg.sender, netAmount, false);
        if (referrals[referralAddress].referralAddress != address(0)) {
            // Referral exists, add to the existing amount
            referrals[referralAddress].amount += referral;
            emit ReferralBonusAdded(referralAddress, referral);
        } else {
            // No existing referral, create new
            referrals[referralAddress] = Referral(msg.sender, referral);
            emit ReferralCreated(referralAddress, referral);
        }
        emit Deposited(msg.sender, netAmount, _note);
    }

    function withdraw(string memory _note, address payable _to) external {
        Deposit storage userDeposit = deposits[_note];

        require(userDeposit.depositor != address(0), "Note not found");
        require(msg.sender == userDeposit.depositor, "Not your deposit");
        require(!userDeposit.withdrawn, "Already withdrawn");
        require(_to != address(0), "Invalid withdrawal address");

        userDeposit.withdrawn = true;
        _to.transfer(userDeposit.amount);

        emit Withdrawn(msg.sender, userDeposit.amount, _to, _note);
    }

    function withdrawReferral() external {
        uint256 bonusAmount = referrals[msg.sender].amount;
        require(bonusAmount > 0, "No referral bonus to withdraw");

        // Set the referral bonus to 0 before transferring to prevent re-entrancy attacks
        referrals[msg.sender].amount = 0;

        // Transfer the bonus amount to the message sender
        address payable sender = payable(msg.sender);
        sender.transfer(bonusAmount);
        
        // Emit an event for the withdrawal
        emit Withdrawal(msg.sender, bonusAmount);
    }

    function getReferralBonus(address user) public view returns (uint256) {
        return referrals[user].amount;
    }

    function getDeposit(string memory _note) external view returns (address, uint256, bool) {
        Deposit storage userDeposit = deposits[_note];
        return (userDeposit.depositor, userDeposit.amount, userDeposit.withdrawn);
    }

    function updateFeeAmount(uint256 _newFeeAmount) external onlyOwner {
        feeAmount = _newFeeAmount;
        emit FeeAmountUpdated(_newFeeAmount);
    }

    function updateFeeAmountTier1(uint256 _newFeeAmount) external onlyOwner {
        feeAmount1 = _newFeeAmount;
        emit FeeAmountUpdated(_newFeeAmount);
    }

    function updateFeeAmountTier2(uint256 _newFeeAmount) external onlyOwner {
        feeAmount2 = _newFeeAmount;
        emit FeeAmountUpdated(_newFeeAmount);
    }

    function updateFeeAmountTier3(uint256 _newFeeAmount) external onlyOwner {
        feeAmount3 = _newFeeAmount;
        emit FeeAmountUpdated(_newFeeAmount);
    }

    function updateReferralAmount(uint256 _newReferralAmount) external onlyOwner {
        referralAmount = _newReferralAmount;
        emit ReferralAmountUpdated(_newReferralAmount);
    }

    function updateReferralAmountTier1(uint256 _newReferralAmount) external onlyOwner {
        referralAmount1 = _newReferralAmount;
        emit ReferralAmountUpdated(_newReferralAmount);
    }

    function updateReferralAmountTier2(uint256 _newReferralAmount) external onlyOwner {
        referralAmount2 = _newReferralAmount;
        emit ReferralAmountUpdated(_newReferralAmount);
    }

    function updateReferralAmountTier3(uint256 _newReferralAmount) external onlyOwner {
        referralAmount3 = _newReferralAmount;
        emit ReferralAmountUpdated(_newReferralAmount);
    }

    function ownerWithdraw() external onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "No funds available");

        payable(owner).transfer(balance);
        emit OwnerWithdrawn(owner, balance);
    }
}