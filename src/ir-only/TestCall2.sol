// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;
import "./PointerLibraries.sol";
import "./t.sol";

function query(
    address target,
    uint256 inSize,
    uint256 outSize
) view {
    assembly {
        if iszero(
            and(
                // The arguments of `and` are evaluated from right to left.
                gt(returndatasize(), sub(outSize, 1)), // At least 32 bytes returned.
                staticcall(gas(), target, 0x1c, inSize, 0x20, outSize)
            )
        ) {
            if returndatasize() {
                returndatacopy(0, 0, returndatasize())
                revert(0, returndatasize())
            }
            // Store the function selector of `ApproveFailed()`.
            mstore(0x00, 0x3e3f8f73)
            // Revert with (offset, size).
            revert(0x1c, 0x04)
        }
    }
}

function queryBalance(address token, address account)
    view
    returns (uint256 amount)
{
    ScratchPtr1.write(0x70a08231);
    ScratchPtr2.write(account);
    query(token, 0x24, 0x20);
    amount = ScratchPtr2.readUint256();
}

/// @dev Returns the amount of ERC20 `token` owned by `account`.
/// Returns zero if the `token` does not exist.
function balanceOf(address token, address account)
    view
    returns (uint256 amount)
{
    /// @solidity memory-safe-assembly
    assembly {
        mstore(0x00, 0x70a08231) // Store the function selector of `balanceOf(address)`.
        mstore(0x20, account) // Store the `account` argument.
        if iszero(
            and(
                // The arguments of `and` are evaluated from right to left.
                gt(returndatasize(), 0x1f), // At least 32 bytes returned.
                staticcall(gas(), token, 0x1c, 0x24, 0x20, 0x20)
            )
        ) {
            if returndatasize() {
                returndatacopy(0, 0, returndatasize())
                revert(0, returndatasize())
            }
            // Store the function selector of `ApproveFailed()`.
            mstore(0x00, 0x3e3f8f73)
            // Revert with (offset, size).
            revert(0x1c, 0x04)
        }
        amount := mload(0x20)
    }
}



contract DoTest2 {
    //solady=3066 other = 3112
    Token public _token = new Token();

    function test(address token, address account)
        external
        view
        returns (uint256)
    {
        return balanceOf(token, account);
    }
}
