// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;
import "./UniswapConstants.sol";

library PairAddress {
    function sortTokens(
        address tokenA,
        address tokenB
    ) internal pure returns (address token0, address token1) {
        (token0, token1) = tokenA < tokenB
            ? (tokenA, tokenB)
            : (tokenB, tokenA);
    }

    /// @dev Calculate keccak256(abi.encodePacked(token0, token1))
    function calculateV2PairSalt(
        address token0,
        address token1
    ) internal pure returns (bytes32 pairSalt) {
        // return keccak256(abi.encodePacked(token0, token1));
        assembly {
            // Write token1 to bytes 32:52
            mstore(V2_pairSalt_Token1_WriteOffset, token1)

            // Write token0 to bytes 12:32
            mstore(V2_pairSalt_Token0_WriteOffset, token0)

            // Hash (token0 . token1) at bytes 12:52
            pairSalt := keccak256(V2_pairSalt_Offset, V2_pairSalt_Size)
        }
    }

    /// @dev Calculate keccak256(abi.encode(token0, token1, fee))
    function calculateV3PairSalt(
        address token0,
        address token1,
        uint24 fee
    ) internal pure returns (bytes32 pairSalt) {
        assembly {
            let ptr := mload(0x40)
            // Write fee to bytes 52:55
            mstore(V3_pairSalt_Fee_WriteOffset, fee)

            // Write token1 to bytes 32:52
            mstore(V3_pairSalt_Token1_WriteOffset, token1)

            // Write token0 to bytes 12:32
            mstore(V3_pairSalt_Token0_WriteOffset, token0)

            // Hash (token0 . token1 . fee) at bytes 12:55
            pairSalt := keccak256(V3_pairSalt_Offset, V3_pairSalt_Size)
            mstore(0x40, ptr)
        }
    }

    function calculateUniswapV3Pair(
        address token0,
        address token1,
        uint24 fee
    ) internal pure returns (address pair) {
        bytes32 pairSalt = calculateV3PairSalt(token0, token1, fee);
        assembly {
            let ptr := mload(0x40)
            // Write 0xff + address to bytes 11:32
            mstore(Create2_Prefix_Offset, UniswapV3_Create2Prefix)

            // Write salt to bytes 32:64
            mstore(Create2_Salt_Offset, pairSalt)

            // Write initcode hash to bytes 64:96
            mstore(Create2_InitCodeHash_Offset, UniswapV3_InitCodeHash)

            // Calculate create2 hash for token0, token1
            // The EVM only looks at the last 20 bytes, so the dirty
            // bits at the beginning do not need to be cleaned
            pair := keccak256(Create2_Offset, Create2_Size)
            mstore(0x40, ptr)
            mstore(0x60, 0)
        }
    }

    function calculateUniswapV2Pair(
        address token0,
        address token1
    ) internal pure returns (address pair) {
        bytes32 pairSalt = calculateV2PairSalt(token0, token1);
        assembly {
            let ptr := mload(0x40)
            // Write 0xff + address to bytes 11:32
            mstore(Create2_Prefix_Offset, UniswapV2_Create2Prefix)

            // Write salt to bytes 32:64
            mstore(Create2_Salt_Offset, pairSalt)

            // Write initcode hash to bytes 64:96
            mstore(Create2_InitCodeHash_Offset, UniswapV2_InitCodeHash)

            // Calculate create2 hash for token0, token1
            // The EVM only looks at the last 20 bytes, so the dirty
            // bits at the beginning do not need to be cleaned
            pair := keccak256(Create2_Offset, Create2_Size)
            mstore(0x40, ptr)
            mstore(0x60, 0)
        }
    }

    function getUniswapV2Pair(
        address tokenA,
        address tokenB
    ) internal pure returns (address pair) {
        (address token0, address token1) = tokenA < tokenB
            ? (tokenA, tokenB)
            : (tokenB, tokenA);
        pair = calculateUniswapV2Pair(token0, token1);
    }

    function calculateSushiswapPair(
        address token0,
        address token1
    ) internal pure returns (address pair) {
        bytes32 pairSalt = calculateV2PairSalt(token0, token1);
        assembly {
            let ptr := mload(0x40)
            // Write 0xff + address to bytes 11:32
            mstore(add(ptr, Create2_Prefix_Offset), Sushiswap_Create2Prefix)

            // Write salt to bytes 32:64
            mstore(add(ptr, Create2_Salt_Offset), pairSalt)

            // Write initcode hash to bytes 64:96
            mstore(
                add(ptr, Create2_InitCodeHash_Offset),
                Sushiswap_InitCodeHash
            )

            // Calculate create2 hash for token0, token1
            // The EVM only looks at the last 20 bytes, so the dirty
            // bits at the beginning do not need to be cleaned
            pair := keccak256(add(ptr, Create2_Offset), Create2_Size)
        }
    }
}

// jump to push = 27 gas (push jumpdest, jump, jumpdest, push address, swap, jump, jumpdest) 9 + 16 + 2 
// codecopy = 21 gas assuming memory expanded (push 32, push ptr, push 0, codecopy, push 0, mload)
// can save another 10 gas if the table with mapping from ids to address is at a power of 2 location in the code, or just early enough