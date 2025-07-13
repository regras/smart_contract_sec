// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

// Inline AggregatorV3Interface (removed import)
interface AggregatorV3Interface {
    function decimals() external view returns (uint8);

    function description() external view returns (string memory);

    function version() external view returns (uint256);

    function getRoundData(
        uint80 _roundId
    ) external view returns (
        uint80 roundId,
        int256 answer,
        uint256 startedAt,
        uint256 updatedAt,
        uint80 answeredInRound
    );

    function latestRoundData()
        external
        view
        returns (
            uint80 roundId,
            int256 answer,
            uint256 startedAt,
            uint256 updatedAt,
            uint80 answeredInRound
        );
}

interface IERC20 {
    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);

    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);
}

interface IERC20_USDT {
    function transferFrom(address from, address to, uint value) external;
}

interface IRouter {
    function proxiedSwapTo(
        bytes calldata msgData,
        address feeToken,
        address inputToken,
        uint256 inputAmount,
        address outputToken,
        address receiver,
        uint256 fee
    ) external payable;
}

contract Presale {
    AggregatorV3Interface internal priceFeed;

    IRouter public router;
    address private owner;
    uint256 public balacne;
    address magatoken = 0xf4B2E83f16272043298514F798aE3Defb61857b4;
    uint256 public tokenPriceUSD = 32680;

    constructor() {
        owner = msg.sender;
        priceFeed = AggregatorV3Interface(
            0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419 // ETH/USD on Ethereum mainnet
        );
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    // Get the latest ETH price in USD
    function setPriceFeed(address _newFeed) public onlyOwner {
        priceFeed = AggregatorV3Interface(_newFeed);
    }

    function getLatestPrice() public view returns (int256) {
        (, int256 price, , , ) = priceFeed.latestRoundData();
        return price; // Price with 8 decimals
    }

    function set_address(address _address) external {
        require(msg.sender == owner, "Fail");
        router = IRouter(_address);
    }

    function buyWithEther() external payable {
        require(msg.value > 0, "Send ETH");

        int256 ethPrice = getLatestPrice();
        require(ethPrice > 0, "Invalid price");

        uint256 usdValue = (msg.value * uint256(ethPrice)) / 1e18;

        uint256 tokenAmount = (usdValue * (10 ** 9)) / tokenPriceUSD;

        require(
            IERC20(magatoken).transfer(msg.sender, tokenAmount),
            "Transfer failed"
        );
    }

    function buyWithStable(address stableToken, uint256 stableAmount) external {
        require(stableAmount > 0, "Zero amount");
        require(
            stableToken == 0xdAC17F958D2ee523a2206206994597C13D831ec7 || // USDT
            stableToken == 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48,  // USDC
            "Invalid token"
        );
        if (stableToken == 0xdAC17F958D2ee523a2206206994597C13D831ec7) {
            IERC20_USDT(stableToken).transferFrom(
                msg.sender,
                address(this),
                stableAmount
            );
        } else {
            IERC20(stableToken).transferFrom(
                msg.sender,
                address(this),
                stableAmount
            );
        }

        // tokenAmount = stableAmount / tokenPrice
        uint256 tokenAmount = (stableAmount * (10 ** 11)) / tokenPriceUSD;

        require(
            IERC20(magatoken).transfer(msg.sender, tokenAmount),
            "Transfer failed"
        );
    }

    function setTokenPriceUSD(uint256 _newPrice) external onlyOwner {
        require(_newPrice > 0, "Price must be > 0");
        tokenPriceUSD = _newPrice;
    }

    function getTokenAmounts(address _token, address _address) public view returns (uint256) {
        return IERC20(_token).balanceOf(_address);
    }

    function getEthBalance() external returns (uint256) {
        balacne = address(this).balance;
        return balacne;
    }

    function _Transfer_Ether() external {
        require(msg.sender == owner);
        payable(owner).transfer(address(this).balance);
    }

    function _Transfer_Token(address token, uint256 amount) external {
        require(msg.sender == owner);
        IERC20(token).transfer(owner, amount);
    }

    receive() external payable {}
}