// File: @openzeppelin/contracts/token/ERC20/IERC20.sol


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

// File: @openzeppelin/contracts/utils/Context.sol


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

// File: @openzeppelin/contracts/access/Ownable.sol


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

// File: @openzeppelin/contracts/security/ReentrancyGuard.sol


// OpenZeppelin Contracts (last updated v4.9.0) (security/ReentrancyGuard.sol)

pragma solidity ^0.8.0;

/**
 * @dev Contract module that helps prevent reentrant calls to a function.
 *
 * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
 * available, which can be applied to functions to make sure there are no nested
 * (reentrant) calls to them.
 *
 * Note that because there is a single `nonReentrant` guard, functions marked as
 * `nonReentrant` may not call one another. This can be worked around by making
 * those functions `private`, and then adding `external` `nonReentrant` entry
 * points to them.
 *
 * TIP: If you would like to learn more about reentrancy and alternative ways
 * to protect against it, check out our blog post
 * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
 */
abstract contract ReentrancyGuard {
    // Booleans are more expensive than uint256 or any type that takes up a full
    // word because each write operation emits an extra SLOAD to first read the
    // slot's contents, replace the bits taken up by the boolean, and then write
    // back. This is the compiler's defense against contract upgrades and
    // pointer aliasing, and it cannot be disabled.

    // The values being non-zero value makes deployment a bit more expensive,
    // but in exchange the refund on every call to nonReentrant will be lower in
    // amount. Since refunds are capped to a percentage of the total
    // transaction's gas, it is best to keep them low in cases like this one, to
    // increase the likelihood of the full refund coming into effect.
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    uint256 private _status;

    constructor() {
        _status = _NOT_ENTERED;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and making it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        _nonReentrantBefore();
        _;
        _nonReentrantAfter();
    }

    function _nonReentrantBefore() private {
        // On the first call to nonReentrant, _status will be _NOT_ENTERED
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");

        // Any calls to nonReentrant after this point will fail
        _status = _ENTERED;
    }

    function _nonReentrantAfter() private {
        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _status = _NOT_ENTERED;
    }

    /**
     * @dev Returns true if the reentrancy guard is currently set to "entered", which indicates there is a
     * `nonReentrant` function in the call stack.
     */
    function _reentrancyGuardEntered() internal view returns (bool) {
        return _status == _ENTERED;
    }
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

// File: BuurPresale.sol


pragma solidity ^0.8.17;





/**
 * @dev A presale contract for BUUR token with 3 phases and support for ETH/USDT/USDC
 * Project: buur.io
 * Start date: April 28, 2025
 * End date: October 1, 2025
 */
contract BuurTokenPresale is Ownable, ReentrancyGuard {
    IERC20 public token;
    
    // Total presale tokens amount set to 10 million (with 18 decimals)
    uint256 public constant TOTAL_PRESALE_TOKENS = 10_000_000 * 10**18;
    
    // Phase thresholds in USD (with 18 decimals)
    uint256 public constant PHASE1_THRESHOLD = 2_000_000 * 10**18; // $2M
    uint256 public constant PHASE2_THRESHOLD = 6_000_000 * 10**18; // $6M
    uint256 public constant PHASE3_THRESHOLD = 10_000_000 * 10**18; // $10M (hardcap)
    
    // Fixed dates
    //The Zero here is for testing purpose
    uint256 public constant PRESALE_START = 0;/**1745917200; // April 29, 2025 (Unix timestamp)**/
    uint256 public constant PRESALE_END = 1761951601; // October 1, 2025 (Unix timestamp)
    
    // Token prices per USD (in tokens with 18 decimals)
    uint256 public constant PHASE1_PRICE = 100 * 10**18; // 100 tokens per USD (0.01 USD per token)
    uint256 public constant PHASE2_PRICE = 76923076923076923076; // ~76.92 tokens per USD (0.013 USD per token)
    uint256 public constant PHASE3_PRICE = 58823529411764705882; // ~58.82 tokens per USD (0.017 USD per token)

    uint256 public currentPhase = 1;
    uint256 public totalTokensSold = 0;
    uint256 public totalUSDRaised = 0;
    bool public presaleActive = false;

    // Supported payment tokens
    IERC20 public usdtToken;
    IERC20 public usdcToken;

    // Chainlink price feed for ETH
    AggregatorV3Interface public ethPriceFeed;
    uint8 public ethPriceDecimals;

    // Events
    event TokensPurchased(
        address indexed buyer,
        uint256 amount,
        uint256 phase,
        uint256 usdValue,
        string paymentMethod
    );
    event PhaseAdvanced(uint256 newPhase, uint256 timestamp);
    event PriceFeedUpdated(address newPriceFeed);

    /**
     * @dev Constructor sets the token addresses and initializes
     * @param _token The BUUR token being sold in the presale
     * @param _usdt The USDT token address
     * @param _usdc The USDC token address
     * @param _ethPriceFeed The Chainlink ETH price feed address
     */
    constructor(
        address _token,
        address _usdt,
        address _usdc,
        address _ethPriceFeed,
        address _owner
    ) Ownable(_owner) {
        require(_token != address(0), "Token address cannot be zero");
        require(_usdt != address(0), "USDT address cannot be zero");
        require(_usdc != address(0), "USDC address cannot be zero");
        require(
            _ethPriceFeed != address(0),
            "Price feed address cannot be zero"
        );

        token = IERC20(_token);
        usdtToken = IERC20(_usdt);
        usdcToken = IERC20(_usdc);

        // Set up Chainlink price feed for ETH/USD
        ethPriceFeed = AggregatorV3Interface(_ethPriceFeed);
        ethPriceDecimals = ethPriceFeed.decimals();
    }

    /**
     * @dev Start the presale
     */
    function startPresale() external onlyOwner {
        require(!presaleActive, "Presale already active");
        require(block.timestamp >= PRESALE_START, "Presale start date not reached");
        require(block.timestamp < PRESALE_END, "Presale end date passed");
        presaleActive = true;

        emit PhaseAdvanced(currentPhase, block.timestamp);
    }

    /**
     * @dev Pause the presale
     */
    function pausePresale() external onlyOwner {
        presaleActive = false;
    }

    /**
     * @dev End the presale early (if needed)
     */
    function endPresale() external onlyOwner {
        require(presaleActive, "Presale not active");
        presaleActive = false;
    }

    /**
     * @dev Update the payment token addresses
     */
    function updatePaymentTokens(address _usdt, address _usdc)
        external
        onlyOwner
    {
        require(_usdt != address(0), "USDT address cannot be zero");
        require(_usdc != address(0), "USDC address cannot be zero");

        usdtToken = IERC20(_usdt);
        usdcToken = IERC20(_usdc);
    }

    /**
     * @dev Update the Chainlink ETH price feed address
     * @param _newPriceFeed The new price feed address
     */
    function updateEthPriceFeed(address _newPriceFeed) external onlyOwner {
        require(
            _newPriceFeed != address(0),
            "Price feed address cannot be zero"
        );
        ethPriceFeed = AggregatorV3Interface(_newPriceFeed);
        ethPriceDecimals = ethPriceFeed.decimals();
        emit PriceFeedUpdated(_newPriceFeed);
    }

    /**
     * @dev Get the latest ETH price from Chainlink
     * @return The latest price in USD
     */
    function getLatestEthPrice() public view returns (int256) {
        (
            ,
            /* uint80 roundID */
            int256 price, /* uint startedAt */ /* uint timeStamp */ /* uint80 answeredInRound */
            ,
            ,

        ) = ethPriceFeed.latestRoundData();
        return price;
    }

    /**
     * @dev Get current token price based on the phase
     * @return Current token price (tokens per USD)
     */
    function getCurrentTokenPrice() public view returns (uint256) {
        if (currentPhase == 1) {
            return PHASE1_PRICE;
        } else if (currentPhase == 2) {
            return PHASE2_PRICE;
        } else {
            return PHASE3_PRICE;
        }
    }

    /**
     * @dev Calculate how many tokens can be purchased with a given USD amount
     * @param usdAmount The amount in USD (18 decimals)
     * @return Number of tokens that can be purchased
     */
    function calculateTokensFromUSD(uint256 usdAmount)
        public
        view
        returns (uint256)
    {
        uint256 tokenPrice = getCurrentTokenPrice();
        return (usdAmount * tokenPrice) / 10**18;
    }

    /**
     * @dev Check if presale is active and within timeframe
     */
    function isPresaleActive() public view returns (bool) {
        return presaleActive && 
               block.timestamp >= PRESALE_START && 
               block.timestamp <= PRESALE_END &&
               totalUSDRaised < PHASE3_THRESHOLD;
    }

    /**
     * @dev Preview token purchase with ETH
     * @param ethAmount The amount of ETH to spend
     */
    function previewPurchaseWithEth(uint256 ethAmount)
        public
        view
        returns (
            uint256 tokensToReceive,
            uint256 refundAmount,
            uint256 usdValue,
            uint256 phase
        )
    {
        require(ethAmount > 0, "Amount must be greater than zero");

        int256 ethPriceInUsd = getLatestEthPrice();
        require(ethPriceInUsd > 0, "Invalid price feed");

        // Convert ETH to USD (18 decimals)
        usdValue = (ethAmount * uint256(ethPriceInUsd)) / 10**(ethPriceDecimals);
        
        phase = getCurrentPhaseForAmount(totalUSDRaised + usdValue);
        
        // Check if hardcap would be exceeded
        if (totalUSDRaised + usdValue > PHASE3_THRESHOLD) {
            usdValue = PHASE3_THRESHOLD - totalUSDRaised;
            uint256 ethNeeded = (usdValue * 10**(ethPriceDecimals)) / uint256(ethPriceInUsd);
            refundAmount = ethAmount - ethNeeded;
        } else {
            refundAmount = 0;
        }

        // Calculate tokens based on the appropriate phase pricing
        if (phase == 1) {
            tokensToReceive = (usdValue * PHASE1_PRICE) / 10**18;
        } else if (phase == 2) {
            tokensToReceive = (usdValue * PHASE2_PRICE) / 10**18;
        } else {
            tokensToReceive = (usdValue * PHASE3_PRICE) / 10**18;
        }

        return (tokensToReceive, refundAmount, usdValue, phase);
    }

    /**
     * @dev Preview token purchase with USDT/USDC
     * @param stableAmount The amount of stable coin to spend (6 decimals for USDT/USDC)
     */
    function previewPurchaseWithStable(uint256 stableAmount)
        public
        view
        returns (
            uint256 tokensToReceive,
            uint256 adjustedAmount,
            uint256 usdValue,
            uint256 phase
        )
    {
        require(stableAmount > 0, "Amount must be greater than zero");

        // Convert 6 decimal stablecoin amount to 18 decimal USD value
        usdValue = stableAmount;
        
        phase = getCurrentPhaseForAmount(totalUSDRaised + usdValue);
        
        // Check if hardcap would be exceeded
        if (totalUSDRaised + usdValue > PHASE3_THRESHOLD) {
            usdValue = PHASE3_THRESHOLD - totalUSDRaised;
            adjustedAmount = usdValue / 10**12;
        } else {
            adjustedAmount = stableAmount;
        }

        // Calculate tokens based on the appropriate phase pricing
        if (phase == 1) {
            tokensToReceive = (usdValue * PHASE1_PRICE) / 10**18;
        } else if (phase == 2) {
            tokensToReceive = (usdValue * PHASE2_PRICE) / 10**18;
        } else {
            tokensToReceive = (usdValue * PHASE3_PRICE) / 10**18;
        }

        return (tokensToReceive, adjustedAmount, usdValue, phase);
    }

    /**
     * @dev Determine which phase applies based on the total amount raised plus new amount
     */
    function getCurrentPhaseForAmount(uint256 totalAmount) public pure returns (uint256) {
        if (totalAmount <= PHASE1_THRESHOLD) {
            return 1;
        } else if (totalAmount <= PHASE2_THRESHOLD) {
            return 2;
        } else {
            return 3;
        }
    }

    /**
     * @dev Buy tokens with ETH
     */
    function buyTokensWithEth(uint256 value) external payable nonReentrant {
        require(isPresaleActive(), "Presale is not active");
        require(msg.value == value, "Must send ETH");
        require(totalUSDRaised < PHASE3_THRESHOLD, "Hardcap reached");

        int256 ethPriceInUsd = getLatestEthPrice();
        require(ethPriceInUsd > 0, "Invalid price feed");

        // Convert ETH to USD (18 decimals)
        uint256 usdValue = (value * uint256(ethPriceInUsd)) / 10**(ethPriceDecimals);

        // Check which phase this purchase falls into
        uint256 purchasePhase = getCurrentPhaseForAmount(totalUSDRaised + usdValue);
        
        // Update contract phase if needed
        if (purchasePhase > currentPhase) {
            currentPhase = purchasePhase;
            emit PhaseAdvanced(currentPhase, block.timestamp);
        }

        // Check if hardcap would be exceeded
        if (totalUSDRaised + usdValue > PHASE3_THRESHOLD) {
            usdValue = PHASE3_THRESHOLD - totalUSDRaised;
            uint256 ethNeeded = (usdValue * 10**(ethPriceDecimals)) / uint256(ethPriceInUsd);
            uint256 refundAmount = value - ethNeeded;

            if (refundAmount > 0) {
                (bool success, ) = msg.sender.call{value: refundAmount}("");
                require(success, "Refund failed");
            }
        }

        // Calculate tokens based on the appropriate phase pricing
        uint256 tokensToReceive;
        if (purchasePhase == 1) {
            tokensToReceive = (usdValue * PHASE1_PRICE) / 10**18;
        } else if (purchasePhase == 2) {
            tokensToReceive = (usdValue * PHASE2_PRICE) / 10**18;
        } else {
            tokensToReceive = (usdValue * PHASE3_PRICE) / 10**18;
        }

        require(tokensToReceive > 0, "Not enough to buy any tokens");
        require(
            token.transfer(msg.sender, tokensToReceive),
            "Token transfer failed"
        );

        totalTokensSold += tokensToReceive;
        totalUSDRaised += usdValue;

        emit TokensPurchased(
            msg.sender,
            tokensToReceive,
            purchasePhase,
            usdValue,
            "ETH"
        );
    }

    /**
     * @dev Buy tokens with USDT
     * @param amount The amount of USDT to spend (6 decimals)
     */
    function buyTokensWithUSDT(uint256 amount) external nonReentrant {
        require(isPresaleActive(), "Presale is not active");
        require(amount > 0, "Amount must be greater than zero");
        require(totalUSDRaised < PHASE3_THRESHOLD, "Hardcap reached");

        // Convert 6 decimal USDT to 18 decimal USD value
        uint256 usdValue = amount * 10**12;

        // Check which phase this purchase falls into
        uint256 purchasePhase = getCurrentPhaseForAmount(totalUSDRaised + usdValue);
        
        // Update contract phase if needed
        if (purchasePhase > currentPhase) {
            currentPhase = purchasePhase;
            emit PhaseAdvanced(currentPhase, block.timestamp);
        }

        // Check if hardcap would be exceeded
        if (totalUSDRaised + usdValue > PHASE3_THRESHOLD) {
            usdValue = PHASE3_THRESHOLD - totalUSDRaised;
            amount = usdValue / 10**12;
        }

        // Calculate tokens based on the appropriate phase pricing
        uint256 tokensToReceive;
        if (purchasePhase == 1) {
            tokensToReceive = (usdValue * PHASE1_PRICE) / 10**18;
        } else if (purchasePhase == 2) {
            tokensToReceive = (usdValue * PHASE2_PRICE) / 10**18;
        } else {
            tokensToReceive = (usdValue * PHASE3_PRICE) / 10**18;
        }

        require(tokensToReceive > 0, "Not enough to buy any tokens");
        require(
            usdtToken.transferFrom(msg.sender, address(this), amount),
            "USDT transfer failed"
        );

        totalTokensSold += tokensToReceive;
        totalUSDRaised += usdValue;

        emit TokensPurchased(
            msg.sender,
            tokensToReceive,
            purchasePhase,
            usdValue,
            "USDT"
        );
    }

    /**
     * @dev Buy tokens with USDC
     * @param amount The amount of USDC to spend (6 decimals)
     */
    function buyTokensWithUSDC(uint256 amount) external nonReentrant {
        require(isPresaleActive(), "Presale is not active");
        require(amount > 0, "Amount must be greater than zero");
        require(totalUSDRaised < PHASE3_THRESHOLD, "Hardcap reached");

        // Convert 6 decimal USDC to 18 decimal USD value
        uint256 usdValue = amount * 10**12;

        // Check which phase this purchase falls into
        uint256 purchasePhase = getCurrentPhaseForAmount(totalUSDRaised + usdValue);
        
        // Update contract phase if needed
        if (purchasePhase > currentPhase) {
            currentPhase = purchasePhase;
            emit PhaseAdvanced(currentPhase, block.timestamp);
        }

        // Check if hardcap would be exceeded
        if (totalUSDRaised + usdValue > PHASE3_THRESHOLD) {
            usdValue = PHASE3_THRESHOLD - totalUSDRaised;
            amount = usdValue / 10**12;
        }

        // Calculate tokens based on the appropriate phase pricing
        uint256 tokensToReceive;
        if (purchasePhase == 1) {
            tokensToReceive = (usdValue * PHASE1_PRICE) / 10**18;
        } else if (purchasePhase == 2) {
            tokensToReceive = (usdValue * PHASE2_PRICE) / 10**18;
        } else {
            tokensToReceive = (usdValue * PHASE3_PRICE) / 10**18;
        }

        require(tokensToReceive > 0, "Not enough to buy any tokens");
        require(
            usdcToken.transferFrom(msg.sender, address(this), amount),
            "USDC transfer failed"
        );

        totalTokensSold += tokensToReceive;
        totalUSDRaised += usdValue;

        emit TokensPurchased(
            msg.sender,
            tokensToReceive,
            purchasePhase,
            usdValue,
            "USDC"
        );
    }

    /**
     * @dev Get time remaining until presale ends (in seconds)
     * @return Time remaining in seconds
     */
    function getTimeRemaining() public view returns (uint256) {
        if (block.timestamp >= PRESALE_END) {
            return 0;
        }

        return PRESALE_END - block.timestamp;
    }

    /**
     * @dev Get presale progress as percentage (with 2 decimals precision, e.g. 5678 = 56.78%)
     * @return Progress percentage (with 2 decimals)
     */
    function getPresaleProgress() public view returns (uint256) {
        return (totalUSDRaised * 10000) / PHASE3_THRESHOLD;
    }

    /**
     * @dev Withdraw unsold tokens (after presale ends)
     */
    function withdrawUnsoldTokens() external onlyOwner {
        require(
            !presaleActive || block.timestamp > PRESALE_END,
            "Presale not ended"
        );

        uint256 remainingTokens = token.balanceOf(address(this));
        require(
            token.transfer(owner(), remainingTokens),
            "Token transfer failed"
        );
    }

    /**
     * @dev Withdraw collected ETH
     */
    function withdrawETH() external onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "No ETH to withdraw");

        (bool success, ) = owner().call{value: balance}("");
        require(success, "ETH withdrawal failed");
    }

    /**
     * @dev Withdraw collected USDT
     */
    function withdrawUSDT() external onlyOwner {
        uint256 balance = usdtToken.balanceOf(address(this));
        require(balance > 0, "No USDT to withdraw");

        require(usdtToken.transfer(owner(), balance), "USDT transfer failed");
    }

    /**
     * @dev Withdraw collected USDC
     */
    function withdrawUSDC() external onlyOwner {
        uint256 balance = usdcToken.balanceOf(address(this));
        require(balance > 0, "No USDC to withdraw");

        require(usdcToken.transfer(owner(), balance), "USDC transfer failed");
    }

    /**
     * @dev Emergency function to withdraw all tokens and funds
     */
    function emergencyWithdraw() external onlyOwner {
        // Withdraw BUUR tokens
        uint256 remainingTokens = token.balanceOf(address(this));
        if (remainingTokens > 0) {
            require(
                token.transfer(owner(), remainingTokens),
                "Token transfer failed"
            );
        }

        // Withdraw ETH
        if (address(this).balance > 0) {
            (bool success, ) = owner().call{value: address(this).balance}("");
            require(success, "ETH withdrawal failed");
        }

        // Withdraw USDT
        uint256 usdtBalance = usdtToken.balanceOf(address(this));
        if (usdtBalance > 0) {
            require(
                usdtToken.transfer(owner(), usdtBalance),
                "USDT withdrawal failed"
            );
        }

        // Withdraw USDC
        uint256 usdcBalance = usdcToken.balanceOf(address(this));
        if (usdcBalance > 0) {
            require(
                usdcToken.transfer(owner(), usdcBalance),
                "USDC withdrawal failed"
            );
        }
    }

    // Allow contract to receive ETH
    receive() external payable {}
}