// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface ISwapRouter {
    struct ExactInputSingleParams {
        address tokenIn;
        address tokenOut;
        uint24 fee;
        address recipient;
        uint256 deadline;
        uint256 amountIn;
        uint256 amountOutMinimum;
        uint160 sqrtPriceLimitX96;
    }

    function exactInputSingle(ExactInputSingleParams calldata params)
        external
        payable
        returns (uint256 amountOut);
}

interface IERC20 {
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
    function transfer(address to, uint256 amount) external returns (bool);
}

interface IWETH {
    function withdraw(uint256 amount) external;
    function transfer(address to, uint256 amount) external returns (bool);
}

abstract contract ReentrancyGuard {
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;
    uint256 private _status;

    constructor() {
        _status = _NOT_ENTERED;
    }

    modifier nonReentrant() {
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
        _status = _ENTERED;
        _;
        _status = _NOT_ENTERED;
    }
}

contract SwapWithFee is ReentrancyGuard {
    address public swapRouter;
    address public feeReceiver;
    address public WETH;
    address public owner;

    uint256 public constant FEE_BPS = 100; // 1%

    event BoughtToken(address indexed user, address tokenOut, uint256 amountIn, uint256 amountOut);
    event SoldToken(address indexed user, address tokenIn, uint256 amountIn, uint256 amountOut);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event ConfigUpdated(string key, address newValue);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    constructor(address _swapRouter, address _feeReceiver, address _weth) {
        require(_swapRouter != address(0), "Invalid swapRouter");
        require(_feeReceiver != address(0), "Invalid feeReceiver");
        require(_weth != address(0), "Invalid WETH");

        swapRouter = _swapRouter;
        feeReceiver = _feeReceiver;
        WETH = _weth;
        owner = msg.sender;
    }

    receive() external payable {}

    function setSwapRouter(address _swapRouter) external onlyOwner {
        require(_swapRouter != address(0) && _swapRouter != swapRouter, "Invalid router");
        swapRouter = _swapRouter;
        emit ConfigUpdated("swapRouter", _swapRouter);
    }

    function setFeeReceiver(address _feeReceiver) external onlyOwner {
        require(_feeReceiver != address(0) && _feeReceiver != feeReceiver, "Invalid receiver");
        feeReceiver = _feeReceiver;
        emit ConfigUpdated("feeReceiver", _feeReceiver);
    }

    function setWETH(address _weth) external onlyOwner {
        require(_weth != address(0) && _weth != WETH, "Invalid WETH");
        WETH = _weth;
        emit ConfigUpdated("WETH", _weth);
    }

    function transferOwnership(address newOwner) external onlyOwner {
        require(newOwner != address(0) && newOwner != owner, "Invalid new owner");
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }

    function buyToken(
        address tokenOut,
        uint24 fee,
        uint256 amountIn,
        uint256 amountOutMin,
        uint160 sqrtPriceLimitX96
    ) external nonReentrant returns (uint256 amountOut) {
        require(tokenOut != address(0) && amountIn > 0 && amountOutMin > 0, "Invalid params");

        require(IERC20(WETH).transferFrom(msg.sender, address(this), amountIn), "TransferFrom failed");

        uint256 feeAmount = (amountIn * FEE_BPS) / 10_000;
        uint256 swapAmount = amountIn - feeAmount;

        require(IERC20(WETH).transfer(feeReceiver, feeAmount), "Fee transfer failed");
        require(IERC20(WETH).approve(swapRouter, swapAmount), "Approve failed");

        ISwapRouter.ExactInputSingleParams memory params = ISwapRouter.ExactInputSingleParams({
            tokenIn: WETH,
            tokenOut: tokenOut,
            fee: fee,
            recipient: msg.sender,
            deadline: block.timestamp + 100,
            amountIn: swapAmount,
            amountOutMinimum: amountOutMin,
            sqrtPriceLimitX96: sqrtPriceLimitX96
        });

        amountOut = ISwapRouter(swapRouter).exactInputSingle(params);
        emit BoughtToken(msg.sender, tokenOut, swapAmount, amountOut);
    }

    function sellToken(
        address tokenIn,
        uint24 fee,
        uint256 amountIn,
        uint256 amountOutMin,
        uint160 sqrtPriceLimitX96
    ) external nonReentrant returns (uint256 amountOut) {
        require(tokenIn != address(0) && amountIn > 0 && amountOutMin > 0, "Invalid params");

        require(IERC20(tokenIn).transferFrom(msg.sender, address(this), amountIn), "TransferFrom failed");
        require(IERC20(tokenIn).approve(swapRouter, amountIn), "Approve failed");

        ISwapRouter.ExactInputSingleParams memory params = ISwapRouter.ExactInputSingleParams({
            tokenIn: tokenIn,
            tokenOut: WETH,
            fee: fee,
            recipient: address(this),
            deadline: block.timestamp + 100,
            amountIn: amountIn,
            amountOutMinimum: amountOutMin,
            sqrtPriceLimitX96: sqrtPriceLimitX96
        });

        amountOut = ISwapRouter(swapRouter).exactInputSingle(params);
        uint256 feeAmount = (amountOut * FEE_BPS) / 10_000;
        uint256 userAmount = amountOut - feeAmount;

        IWETH(WETH).withdraw(feeAmount);
        (bool sent, ) = payable(feeReceiver).call{value: feeAmount}("");
        require(sent, "ETH fee send failed");

        require(IERC20(WETH).transfer(msg.sender, userAmount), "Send WETH failed");
        emit SoldToken(msg.sender, tokenIn, amountIn, userAmount);
    }
}