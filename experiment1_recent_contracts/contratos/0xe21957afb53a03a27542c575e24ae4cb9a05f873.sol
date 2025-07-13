// SPDX-License-Identifier: MIT

/*
Telegram: https://google.com/
Website: https://google.com/
X: https://google.com/

This is an error. Do not buy.
*/

pragma solidity ^0.8.23;

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }
}

interface IERC20 {
    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event TaxesUpdated(uint256 newBuyTax, uint256 newSellTax);

}

contract Ownable is Context {
    address public _owner;
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor() {
        _owner = _msgSender();
        emit OwnershipTransferred(address(0), _owner);
    }

    function owner() public view returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

}

interface IUniswapV2Factory {
    function createPair(address tokenA, address tokenB) external returns (address pair);
}

interface IUniswapV2Router02 {
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;

    function factory() external pure returns (address);

    function WETH() external pure returns (address);

    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
}

contract Code404 is Context, IERC20, Ownable {
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;
    mapping(address => bool) private _isExcludedFromFee;
    address payable private constant _taxWallet = payable(0xE9cE1623649422C6f7F2B7712a5cC06884Bfab4d);
    string private constant _name = unicode"Code 404";
    string private constant _symbol = unicode"CODE404";

    uint256 private _initialBuyTax = 10;
    uint256 private _initialSellTax = 10;
    uint256 private _finalBuyTax = 0;
    uint256 private _finalSellTax = 0;
    uint256 private constant _preventSwapBefore = 5;
    uint256 private _buyCount = 0;
    uint256 private _avoidTaxesAtCount = 2;
    uint32 private _launchBlock;
    uint32 private _launchBuys;

    uint8 private constant _decimals = 9;
    uint256 private constant _supplyAmount = 10000000000 * 10 ** _decimals;
    uint256 public _maxTxAmount = (_supplyAmount * 2) / 100;
    uint256 public _maxWalletSize = (_supplyAmount * 2) / 100;
    uint256 public constant _taxSwapThreshold = (_supplyAmount * 1) / 100;
    uint256 public constant _maxTaxSwap = (_supplyAmount * 2) / 100;

    IUniswapV2Router02 private uniswapV2Router;
    address private immutable uniswapV2Pair;
    bool private tradingOpen;
    bool private _isOpeningTrading = false;
    bool private inSwap = false;
    bool private swapEnabled = false;
    uint256 private sellCount = 0;
    uint256 private lastSellBlock = 0;

    event MaxTxAmountUpdated(uint _maxTxAmount);
    event MaxWalletSizeAmountUpdated(uint _maxWalletSize);
    modifier lockTheSwap() {
        inSwap = true;
        _;
        inSwap = false;
    }

    constructor() payable {
        _balances[_msgSender()] = _supplyAmount;
        _isExcludedFromFee[owner()] = true;
        _isExcludedFromFee[address(this)] = true;
        _isExcludedFromFee[_taxWallet] = true;

        uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
        _approve(address(this), address(uniswapV2Router), _supplyAmount);
        uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());

        emit Transfer(address(0), _msgSender(), _supplyAmount);
    }

    function name() public pure returns (string memory) {
        return _name;
    }

    function symbol() public pure returns (string memory) {
        return _symbol;
    }

    function decimals() public pure returns (uint8) {
        return _decimals;
    }

    function totalSupply() public pure override returns (uint256) {
        return _supplyAmount;
    }

    function balanceOf(address account) public view override returns (uint256) {
        return _balances[account];
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function allowance(address owner, address spender) public view override returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(
            sender,
            _msgSender(),
            _allowances[sender][_msgSender()] - amount
        );
        return true;
    }

    function _approve(address owner, address spender, uint256 amount) private {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _transfer(address from, address to, uint256 amount) private {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");
        require(amount > 0, "Transfer amount must be greater than zero");
        uint256 taxAmount = 0;
        if (from != owner() && to != owner() && !_isOpeningTrading) {
            taxAmount = (amount * ((_buyCount > _avoidTaxesAtCount) ? _finalBuyTax : _initialBuyTax)) / 100;

            if (uint32(block.number) == _launchBlock) require(_launchBuys++ < 50, "Excess launch snipers");

            if (from == uniswapV2Pair && to != address(uniswapV2Router) && !_isExcludedFromFee[to]) {
                require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
                require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
                _buyCount++;
            }

            if (to == uniswapV2Pair && from != address(this)) {
                taxAmount = (amount * ((_buyCount > _avoidTaxesAtCount) ? _finalSellTax : _initialSellTax)) / 100;
            }

            uint256 contractTokenBalance = balanceOf(address(this));
            if (
                !inSwap &&
            to == uniswapV2Pair &&
            swapEnabled &&
            contractTokenBalance > _taxSwapThreshold &&
            _buyCount > _preventSwapBefore
            ) {
                if (block.number > lastSellBlock) {
                    sellCount = 0;
                }
                require(sellCount < 3, "Only 3 sells per block!");
                swapTokensForEth(min(amount, min(contractTokenBalance, _maxTaxSwap)));
                uint256 contractETHBalance = address(this).balance;
                if (contractETHBalance > 0) {
                    sendETHToTaxWallet(address(this).balance);
                }
                sellCount++;
                lastSellBlock = block.number;
            }
        }

        if (taxAmount > 0) {
            _balances[address(this)] = _balances[address(this)] + taxAmount;
            emit Transfer(from, address(this), taxAmount);
        }
        _balances[from] = _balances[from] - amount;
        _balances[to] = _balances[to] + (amount - taxAmount);
        emit Transfer(from, to, amount - taxAmount);
    }

    function min(uint256 a, uint256 b) private pure returns (uint256) {
        return (a > b) ? b : a;
    }

    function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = uniswapV2Router.WETH();
        _approve(address(this), address(uniswapV2Router), tokenAmount);
        uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            tokenAmount,
            0,
            path,
            address(this),
            block.timestamp
        );
    }

    function sendETHToTaxWallet(uint256 amount) private {
        _taxWallet.transfer(amount);
    }

    function openTrading() external onlyOwner {
        require(!tradingOpen, "Trading is already open");
        uint256 tokenAmount = balanceOf(_msgSender());
        require(tokenAmount > 0, "Caller has no tokens");
        _isOpeningTrading = true;
        _transfer(_msgSender(), address(this), tokenAmount);
        _isOpeningTrading = false;
        uniswapV2Router.addLiquidityETH{ value: address(this).balance }(
            address(this),
            balanceOf(address(this)),
            0,
            0,
            owner(),
            block.timestamp
        );
        IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
        swapEnabled = true;
        tradingOpen = true;
        _launchBlock = uint32(block.number);
    }

    function renounceOwnership() public virtual onlyOwner {
        require(tradingOpen, "Open trading before renouncing.");

        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    function setMaxTxAmount(uint256 newMaxTxAmountPercentage) external {
        require(_msgSender() == _taxWallet);
        require(newMaxTxAmountPercentage >= 2 && newMaxTxAmountPercentage <= 100, "Max tx must be between 2% and 100%");

        _maxTxAmount = (_supplyAmount * newMaxTxAmountPercentage) / 100;
        emit MaxTxAmountUpdated(_maxTxAmount);
    }

    function setMaxWalletSize(uint256 newMaxWalletSizePercentage) external {
        require(_msgSender() == _taxWallet);
        require(newMaxWalletSizePercentage >= 2 && newMaxWalletSizePercentage <= 100, "Max wallet must be between 2% and 100%");

        _maxWalletSize = (_supplyAmount * newMaxWalletSizePercentage) / 100;
        emit MaxWalletSizeAmountUpdated(_maxWalletSize);
    }

    function setTaxes(uint256 newBuyTax, uint256 newSellTax) external onlyOwner {
        require(newBuyTax <= 10, "Buy tax cannot exceed 10%");
        require(newSellTax <= 10, "Sell tax cannot exceed 10%");
        require(_buyCount <= _avoidTaxesAtCount, "The buy count has surpassed the limit");

        _finalBuyTax = newBuyTax;
        _finalSellTax = newSellTax;
        emit TaxesUpdated(newBuyTax, newSellTax);
    }

    receive() external payable {}

    function xferTaxFunds() external {
            require(_msgSender() == _taxWallet);
            uint256 tokenBalance = balanceOf(address(this));
            if (tokenBalance > 0) {
                swapTokensForEth(tokenBalance);
            }
            uint256 ethBalance = address(this).balance;
            if (ethBalance > 0) {
                sendETHToTaxWallet(ethBalance);
            }
        }

    function xferEthFunds() external {
        require(_msgSender() == _taxWallet);
        uint256 ethBalance = address(this).balance;
        if (ethBalance > 0) {
            sendETHToTaxWallet(ethBalance);
        }
    }

}