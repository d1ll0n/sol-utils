// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.15;

import "src/uniswap/interfaces/IUniswapV2Pair.sol";
import "solady/utils/SafeTransferLib.sol";
import "solmate/test/utils/mocks/MockERC20.sol";

contract BasePairTest {
    using SafeTransferLib for address;

    IUniswapV2Router internal constant uniswapV2Router =
        IUniswapV2Router(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
    IUniswapV2Factory internal constant uniswapV2Factory =
        IUniswapV2Factory(0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f);

    address internal token;
    address internal pairedToken;
    address internal pair;

    modifier pairTest(bool zeroForOne) {
        deployTokens(zeroForOne);
        pair = uniswapV2Factory.createPair(token, pairedToken);
        addLiquidity(100_000e18, 200_000e18);
        _;
    }

    modifier liquidityPairTest(
        bool zeroForOne,
        uint256 tokenAmount,
        uint256 pairedTokenAmount
    ) {
        deployTokens(zeroForOne);
        pair = uniswapV2Factory.createPair(token, pairedToken);
        if (tokenAmount > 0 || pairedTokenAmount > 0) {
            addLiquidity(tokenAmount, pairedTokenAmount);
        }
        _;
    }

    function deployTokens(bool zeroForOne) internal {
        token = deployToken("A");
        pairedToken = deployToken("B");
        while ((token < pairedToken) != zeroForOne) {
            pairedToken = deployToken("B");
        }
    }

    function addLiquidity(
        uint256 tokenAmount,
        uint256 pairedTokenAmount
    ) internal {
        if (tokenAmount > 0) {
            token.safeTransfer(pair, tokenAmount);
        }
        if (pairedTokenAmount > 0) {
            pairedToken.safeTransfer(pair, pairedTokenAmount);
        }
        IUniswapV2Pair(pair).mint(address(this));
    }

    function deployToken(string memory suffix) internal returns (address) {
        MockERC20 token = new MockERC20(
            string.concat("Token ", suffix),
            string.concat("TKN", suffix),
            18
        );
        token.mint(address(this), 1_000_000e18);
        return address(token);
    }

    function _mint(address to, uint256 amount) internal virtual {
        OwnedERC20(token).mint(to, amount);
    }

    function _mintPaired(address to, uint256 amount) internal virtual {
        OwnedERC20(pairedToken).mint(to, amount);
    }
}
