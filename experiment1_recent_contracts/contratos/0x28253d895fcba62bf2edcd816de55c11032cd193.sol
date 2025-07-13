// SPDX-License-Identifier: MIT
// File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol


// OpenZeppelin Contracts (last updated v5.0.1) (utils/Context.sol)

pragma solidity ^0.8.20;

/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }

    function _contextSuffixLength() internal view virtual returns (uint256) {
        return 0;
    }
}

// File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol


// OpenZeppelin Contracts (last updated v5.0.0) (access/Ownable.sol)

pragma solidity ^0.8.20;


/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * The initial owner is set to the address provided by the deployer. This can
 * later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
    address private _owner;

    /**
     * @dev The caller account is not authorized to perform an operation.
     */
    error OwnableUnauthorizedAccount(address account);

    /**
     * @dev The owner is not a valid owner account. (eg. `address(0)`)
     */
    error OwnableInvalidOwner(address owner);

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the address provided by the deployer as the initial owner.
     */
    constructor(address initialOwner) {
        if (initialOwner == address(0)) {
            revert OwnableInvalidOwner(address(0));
        }
        _transferOwnership(initialOwner);
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if the sender is not the owner.
     */
    function _checkOwner() internal view virtual {
        if (owner() != _msgSender()) {
            revert OwnableUnauthorizedAccount(_msgSender());
        }
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby disabling any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        if (newOwner == address(0)) {
            revert OwnableInvalidOwner(address(0));
        }
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

// File: https://github.com/openzeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol


// OpenZeppelin Contracts (last updated v5.1.0) (token/ERC20/IERC20.sol)

pragma solidity ^0.8.20;

/**
 * @dev Interface of the ERC-20 standard as defined in the ERC.
 */
interface IERC20 {
    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /**
     * @dev Returns the value of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the value of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves a `value` amount of tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 value) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets a `value` amount of tokens as the allowance of `spender` over the
     * caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 value) external returns (bool);

    /**
     * @dev Moves a `value` amount of tokens from `from` to `to` using the
     * allowance mechanism. `value` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address from, address to, uint256 value) external returns (bool);
}

// File: @chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol


pragma solidity ^0.8.0;

interface AggregatorV3Interface {
  function decimals() external view returns (uint8);

  function description() external view returns (string memory);

  function version() external view returns (uint256);

  function getRoundData(
    uint80 _roundId
  ) external view returns (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound);

  function latestRoundData()
    external
    view
    returns (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound);
}

// File: trisig/presale.sol


pragma solidity ^0.8.26;




contract TRISIGPresale is Ownable {
    AggregatorV3Interface public priceFeed = AggregatorV3Interface(0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419);

    //Struct for Buyers
    struct tokenBuyer{
        uint256 tokensBought;
    }

    //Mapping for Buyers
    mapping (address => tokenBuyer) public Buyers;

    // The token being sold
    IERC20 public immutable token = IERC20(0xf19C63ceFA7C5F1a73A7441554103fD2885D1752);

    //USDT token address
    IERC20 public immutable usdt = IERC20(0xdAC17F958D2ee523a2206206994597C13D831ec7);

    //USDC token address
    IERC20 public immutable usdc = IERC20(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);

    //tokens that can be claimed
    uint256 private claimableTokens;

    // Address where funds are collected
    address public wallet = payable(0xE99836ef9DA18Aeb47D59d051bc9D188De9d233b);

    // How many token units a buyer gets per ETH & USDT
    uint256 public tokenPriceUSD = 80;

    // Amount of wei raised
    uint256 private weiRaised;
    uint256 private usdtRaised;
    uint256 private usdcRaised;

    //Amount of tokens sold
    uint256 private tokensSold;

    //Presale status
    bool private hasPresaleStarted;
    bool private hasPresaleEnded;

    constructor() Ownable(msg.sender) {
    }

    receive() external payable {
        buyTokens();
    }
    
    //START PRESALE
    function startPresale() public onlyOwner{
        hasPresaleStarted = true;
    }

    //END PRESALE
    function endPresale() public onlyOwner{
        hasPresaleEnded = true;
    }

    // BUY TOKENS WITH ETH
    function buyTokens() public payable {
        require(hasPresaleStarted,"Presale not started");
        require(!hasPresaleEnded, "Presale has ended");
        require(msg.value >= 0.001 ether, "Can't buy less with than 0.001 ETH");
        uint256 weiAmount = msg.value;
        //uint256 tokens = weiAmount * ethRate;

        int256 ethPrice = getETHPriceInUSD();
        require(ethPrice > 0, "Invalid ETH price");

        uint256 tokenAmount = (weiAmount * uint256(ethPrice) * 1000) / tokenPriceUSD / (10 ** priceFeed.decimals());
        require(claimableTokens >= tokenAmount, "Not enough tokens availible");

        weiRaised += weiAmount;

        Buyers[msg.sender].tokensBought += tokenAmount;
        tokensSold += tokenAmount;
        claimableTokens -= tokenAmount;

        (bool callSuccess, ) = payable(wallet).call{value: msg.value}("");
        require(callSuccess, "Call failed");
    }

    //BUY TOKENS WITH USDT
    function buyTokensWithUSDT(uint256 amount) public {
        require(hasPresaleStarted,"Presale not started");
        require(!hasPresaleEnded, "Presale has ended");
        require(amount >= 1 * 10 ** 6, "Can't buy less with than 1 USDT");
        uint256 weiAmount = amount * 10 ** 12;
        uint256 tokens = weiAmount * 1000 / tokenPriceUSD;
        require(claimableTokens >= tokens, "Not enough tokens availible");

        usdtRaised += amount;

        Buyers[msg.sender].tokensBought += tokens;
        tokensSold += tokens;
        claimableTokens -= tokens;

        usdt.transferFrom(msg.sender, wallet, amount);
    }

    //BUY TOKENS WITH USDC
    function buyTokensWithUSDC(uint256 amount) public {
        require(hasPresaleStarted,"Presale not started");
        require(!hasPresaleEnded, "Presale has ended");
        require(amount >= 1 * 10 ** 6, "Can't buy less with than 1 USDC");
        uint256 weiAmount = amount * 10 ** 12;
        uint256 tokens = weiAmount * 1000 / tokenPriceUSD;
        require(claimableTokens >= tokens, "Not enough tokens availible");

        usdcRaised += amount;

        Buyers[msg.sender].tokensBought += tokens;
        tokensSold += tokens;
        claimableTokens -= tokens;

        usdc.transferFrom(msg.sender, wallet, amount);
    }

    //DEPOSIT TOKENS FOR PRESALE
    function deposit(uint amount) external onlyOwner {
        require(amount > 0, "Deposit value must be greater than 0");
        token.transferFrom(msg.sender, address(this), amount);
        claimableTokens += amount;
    }

    //WITHDRAW UNSOLD TOKENS IF NEEDED
    function withdraw(uint amount) external onlyOwner {
        require(
            token.balanceOf(address(this)) > 0,
            "There are not enough tokens in contract"
        );
        require(claimableTokens >= amount, "Not enough tokens to withdraw");
        token.transfer(msg.sender, amount);
        claimableTokens -= amount;
    }

    // CLAIM FUNCTION
    function claimTokens() public {
        require(hasPresaleEnded,"Presale has not ended");
        require(Buyers[msg.sender].tokensBought > 0, "No tokens to be claimed");

        uint256 amount = Buyers[msg.sender].tokensBought;

        token.transfer(msg.sender, amount);

        Buyers[msg.sender].tokensBought = 0;
    }

    //TO CHANGE COLLECTION WALLET
    function changeWallet(address payable _wallet) external onlyOwner {
        wallet = _wallet;
    }

    //TO UPDATE RATES
    function changeRate(uint256 _ethToUsd) public onlyOwner {
        tokenPriceUSD = _ethToUsd;
    }

    // ALL GETTER FUNCTIONS TO RETRIEVE DATA

    function checkbalance() external view returns (uint256) {
        return token.balanceOf(address(this));
    }

   function getETHPriceInUSD() public view returns (int256) {
        (, int256 price, , , ) = priceFeed.latestRoundData();
        return price;
    }

    function getTokenUsdPrice() public view returns (uint256) {
        return tokenPriceUSD;
    }

    function progressETH() public view returns (uint256) {
        return weiRaised;
    }

    function progressUSDT() public view returns (uint256) {
        return usdtRaised;
    }

    function progressUSDC() public view returns (uint256) {
        return usdcRaised;
    }

    function soldTokens() public view returns (uint256) {
        return tokensSold;
    }

    function checkPresaleStatus() public view returns (bool) {
        return hasPresaleStarted;
    }

    function checkPresaleEnd() public view returns (bool) {
        return hasPresaleEnded;
    }

    function getClaimableTokens() public view returns (uint256) {
        return claimableTokens;
    }

}