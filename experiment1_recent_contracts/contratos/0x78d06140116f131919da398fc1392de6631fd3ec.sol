// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.29;

interface IERC20 {
    function balanceOf(address account) external view returns (uint256);
    function transfer(
        address recipient,
        uint256 amount
    ) external returns (bool);
}

interface IUniswapV2Pair {
    function getReserves()
        external
        view
        returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
    function swap(
        uint amount0Out,
        uint amount1Out,
        address to,
        bytes calldata data
    ) external;
}

contract ShowMeVolume {
    address immutable owner = msg.sender;

    function buy(bytes calldata GRDUSDT, bytes calldata GRDWETH) external {
        require(msg.sender == owner);
        buyGRDUSDT(GRDUSDT);
        buyGRDWETH(GRDWETH);
    }

    function buyGRDUSDT(bytes calldata GRDUSDT) internal {
        (
            uint256 amountInUniswapV2USDT,
            uint256 amountOutUniswapV2GRD,
            uint256 amountInSushiSwapV2USDT,
            uint256 amountOutSushiSwapV2GRD
        ) = abi.decode(GRDUSDT, (uint256, uint256, uint256, uint256));
        IERC20(0xdAC17F958D2ee523a2206206994597C13D831ec7).transfer(
            0xbD22cB0eD1E81b451f5EB408De7190401c4EbE84,
            amountInUniswapV2USDT
        );
        IUniswapV2Pair(0xbD22cB0eD1E81b451f5EB408De7190401c4EbE84).swap(
            amountOutUniswapV2GRD,
            0,
            address(this),
            ""
        );
        IERC20(0xdAC17F958D2ee523a2206206994597C13D831ec7).transfer(
            0x27d382D10C21c746BA3fBB082AF5F6dB5F56523c,
            amountInSushiSwapV2USDT
        );
        IUniswapV2Pair(0x27d382D10C21c746BA3fBB082AF5F6dB5F56523c).swap(
            amountOutSushiSwapV2GRD,
            0,
            address(this),
            ""
        );
    }

    function buyGRDWETH(bytes calldata GRDWETH) internal {
        (
            uint256 amountInUniswapV2WETH,
            uint256 amountOutUniswapV2GRD,
            uint256 amountInSushiSwapV2WETH,
            uint256 amountOutSushiSwapV2GRD
        ) = abi.decode(GRDWETH, (uint256, uint256, uint256, uint256));
        IERC20(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2).transfer(
            0xA47fe0a5dF795BeA0BB12d0Fa9a01e8bF3714e33,
            amountInUniswapV2WETH
        );
        IUniswapV2Pair(0xA47fe0a5dF795BeA0BB12d0Fa9a01e8bF3714e33).swap(
            amountOutUniswapV2GRD,
            0,
            address(this),
            ""
        );
        IERC20(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2).transfer(
            0xaa1bF45993A531772882D9d2440be4ba7C201067,
            amountInSushiSwapV2WETH
        );
        IUniswapV2Pair(0xaa1bF45993A531772882D9d2440be4ba7C201067).swap(
            amountOutSushiSwapV2GRD,
            0,
            address(this),
            ""
        );
    }

    function sell(bytes calldata GRDUSDT, bytes calldata GRDWETH) external {
        require(msg.sender == owner);
        sellGRDUSDT(GRDUSDT);
        sellGRDWETH(GRDWETH);
    }

    function sellGRDUSDT(bytes calldata GRDUSDT) internal {
        (
            uint256 amountInUniswapV2GRD,
            uint256 amountOutUniswapV2USDT,
            uint256 amountInSushiSwapV2GRD,
            uint256 amountOutSushiSwapV2USDT
        ) = abi.decode(GRDUSDT, (uint256, uint256, uint256, uint256));
        IERC20(0x2445EE0B87B5C7f4D069A14b21a4838b70aa83ED).transfer(
            0xbD22cB0eD1E81b451f5EB408De7190401c4EbE84,
            amountInUniswapV2GRD
        );
        IUniswapV2Pair(0xbD22cB0eD1E81b451f5EB408De7190401c4EbE84).swap(
            0,
            amountOutUniswapV2USDT,
            address(this),
            ""
        );
        IERC20(0x2445EE0B87B5C7f4D069A14b21a4838b70aa83ED).transfer(
            0x27d382D10C21c746BA3fBB082AF5F6dB5F56523c,
            amountInSushiSwapV2GRD
        );
        IUniswapV2Pair(0x27d382D10C21c746BA3fBB082AF5F6dB5F56523c).swap(
            0,
            amountOutSushiSwapV2USDT,
            address(this),
            ""
        );
    }

    function sellGRDWETH(bytes calldata GRDWETH) internal {
        (
            uint256 amountInUniswapV2GRD,
            uint256 amountOutUniswapV2USDT,
            uint256 amountInSushiSwapV2GRD,
            uint256 amountOutSushiSwapV2USDT
        ) = abi.decode(GRDWETH, (uint256, uint256, uint256, uint256));
        IERC20(0x2445EE0B87B5C7f4D069A14b21a4838b70aa83ED).transfer(
            0xA47fe0a5dF795BeA0BB12d0Fa9a01e8bF3714e33,
            amountInUniswapV2GRD
        );
        IUniswapV2Pair(0xA47fe0a5dF795BeA0BB12d0Fa9a01e8bF3714e33).swap(
            0,
            amountOutUniswapV2USDT,
            address(this),
            ""
        );
        IERC20(0x2445EE0B87B5C7f4D069A14b21a4838b70aa83ED).transfer(
            0xaa1bF45993A531772882D9d2440be4ba7C201067,
            amountInSushiSwapV2GRD
        );
        IUniswapV2Pair(0xaa1bF45993A531772882D9d2440be4ba7C201067).swap(
            0,
            amountOutSushiSwapV2USDT,
            address(this),
            ""
        );
    }

    function getReservesWETHUSDT()
        public
        view
        returns (uint112 reserveWETH, uint112 reserveUSDT)
    {
        (reserveWETH, reserveUSDT, ) = IUniswapV2Pair(
            0x0d4a11d5EEaaC28EC3F61d100daF4d40471f1852
        ).getReserves();
    }

    function poolsData()
        public
        view
        returns (bytes memory GRDUSDT, bytes memory GRDWETH)
    {
        GRDUSDT = poolsDataGRDUSDT();
        GRDWETH = poolsDataGRDWETH();
    }

    function poolsDataGRDUSDT() internal view returns (bytes memory GRDUSDT) {
        (
            uint112 uniswapV2Reserve0,
            uint112 uniswapV2Reserve1,

        ) = IUniswapV2Pair(0xbD22cB0eD1E81b451f5EB408De7190401c4EbE84)
                .getReserves();
        (
            uint112 sushiswapV2Reserve0,
            uint112 sushiswapV2Reserve1,

        ) = IUniswapV2Pair(0x27d382D10C21c746BA3fBB082AF5F6dB5F56523c)
                .getReserves();
        GRDUSDT = abi.encode(
            uniswapV2Reserve0,
            uniswapV2Reserve1,
            sushiswapV2Reserve0,
            sushiswapV2Reserve1
        );
    }

    function poolsDataGRDWETH() internal view returns (bytes memory GRDWETH) {
        (
            uint112 uniswapV2Reserve0,
            uint112 uniswapV2Reserve1,

        ) = IUniswapV2Pair(0xA47fe0a5dF795BeA0BB12d0Fa9a01e8bF3714e33)
                .getReserves();
        (
            uint112 sushiswapV2Reserve0,
            uint112 sushiswapV2Reserve1,

        ) = IUniswapV2Pair(0xaa1bF45993A531772882D9d2440be4ba7C201067)
                .getReserves();
        GRDWETH = abi.encode(
            uniswapV2Reserve0,
            uniswapV2Reserve1,
            sushiswapV2Reserve0,
            sushiswapV2Reserve1
        );
    }

    function getBalances()
        public
        view
        returns (uint256 balanceGRD, uint256 balanceUSDT, uint256 balanceWETH)
    {
        balanceGRD = IERC20(0x2445EE0B87B5C7f4D069A14b21a4838b70aa83ED)
            .balanceOf(address(this));
        balanceUSDT = IERC20(0xdAC17F958D2ee523a2206206994597C13D831ec7)
            .balanceOf(address(this));
        balanceWETH = IERC20(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2)
            .balanceOf(address(this));
    }

    function widthdraw() external {
        require(msg.sender == owner);
        uint256 balanceGRD = IERC20(0x2445EE0B87B5C7f4D069A14b21a4838b70aa83ED)
            .balanceOf(address(this));
        uint256 balanceUSDT = IERC20(0xdAC17F958D2ee523a2206206994597C13D831ec7)
            .balanceOf(address(this));
        uint256 balanceWETH = IERC20(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2)
            .balanceOf(address(this));
        if (balanceGRD > 0) {
            IERC20(0x2445EE0B87B5C7f4D069A14b21a4838b70aa83ED).transfer(
                msg.sender,
                balanceGRD
            );
        }
        if (balanceUSDT > 0) {
            IERC20(0xdAC17F958D2ee523a2206206994597C13D831ec7).transfer(
                msg.sender,
                balanceUSDT
            );
        }
        if (balanceWETH > 0) {
            IERC20(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2).transfer(
                msg.sender,
                balanceWETH
            );
        }
    }
}