// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./PointerLibraries.sol";

/*
function map(
  uint[] memory arr,
  function(uint) pure returns (uint32) cb
)  pure returns (uint32[] memory newArray) {
  function (uint256) internal pure returns (uint256) genericCallback;
  assembly { genericCallback := cb }
  MemoryPointer newArrayPointer = arr.toPointer().map(
    genericCallback
  );
  assembly { newArray := newArrayPointer }
}
*/

library ArrayMap {
    /**
     * @dev Execute a callback function on each element of an array
     *      and returns an array that contains the results
     *
     * @param array   the array to map
     * @param fn      a function that accepts each element in the array and
     *                returns a new value to put in its place in the new array
     *
     * Note:  The `uint256` input and output on `fn` are stand-ins as Solidity
     *        has no `any` type. The real callback function should accept the
     *        element type of `array` and return the element type of `newArray`.
     *        The function signature should be type-cast for compatibility.
     *
     * @return newArray the new array created with the results from calling
     *         `fn` with each element
     */
    function map(
        MemoryPointer array,
        function(uint256) internal pure returns (uint256) fn
    ) internal pure returns (MemoryPointer newArray) {
        unchecked {
            uint256 length = array.readUint256();

            newArray = malloc((length + 1) * 32);
            newArray.write(length);

            MemoryPointer srcPosition = array.next();
            MemoryPointer srcEnd = srcPosition.offset(length * 0x20);
            MemoryPointer dstPosition = newArray.next();

            while (srcPosition.lt(srcEnd)) {
                dstPosition.write(fn(srcPosition.readUint256()));
                srcPosition = srcPosition.next();
                dstPosition = dstPosition.next();
            }
        }
    }

    /**
     * @dev mapWithIndex calls a callback function with each element of an
     *      array and its index and returns an array that contains the results
     *
     * @param array   the array to map
     * @param fn      a function that accepts each element in the array and
     *                its index and returns a new value to put in its place
     *                in the new array
     *
     * @return newArray the new array created with the results from calling
     *         fn with each element
     */
    function mapWithIndex(
        MemoryPointer array,
        function(uint256, uint256) internal pure returns (uint256) fn
    ) internal pure returns (MemoryPointer newArray) {
        unchecked {
            uint256 length = array.readUint256();

            newArray = malloc((length + 1) * 32);
            newArray.write(length);

            MemoryPointer srcPosition = array.next();
            MemoryPointer srcEnd = srcPosition.offset(length * 0x20);
            MemoryPointer dstPosition = newArray.next();

            uint256 index;
            while (srcPosition.lt(srcEnd)) {
                dstPosition.write(fn(srcPosition.readUint256(), index++));
                srcPosition = srcPosition.next();
                dstPosition = dstPosition.next();
            }
        }
    }

    /**
     * @dev Execute a callback function on each element of an array
     *      and returns an array that contains the results
     *
     * @param array   the array to map
     * @param fn      a function that accepts each element in the array and
     *                `input`, and returns a new value to put in each element's
     *                place in the new array
     *
     * Note:  The `uint256` inputs and output on `fn` are stand-ins as Solidity
     *        has no `any` type. The real callback function should accept the
     *        element type of `array` and the type of `input` and return the
     *        element type of `newArray`.
     *        The function signature should be type-cast for compatibility.
     *
     * @return newArray the new array created with the results from calling
     *         `fn` with each element
     */
    function mapWithArg(
        MemoryPointer array,
        uint256 arg,
        function(uint256, uint256) internal pure returns (uint256) fn
    ) internal pure returns (MemoryPointer newArray) {
        unchecked {
            uint256 length = array.readUint256();

            newArray = malloc((length + 1) * 32);
            newArray.write(length);

            MemoryPointer srcPosition = array.next();
            MemoryPointer srcEnd = srcPosition.offset(length * 0x20);
            MemoryPointer dstPosition = newArray.next();

            while (srcPosition.lt(srcEnd)) {
                dstPosition.write(fn(srcPosition.readUint256(), arg));
                srcPosition = srcPosition.next();
                dstPosition = dstPosition.next();
            }
        }
    }

    /**
     * @dev mapWithIndex calls a callback function with each element of an
     *      array and its index and returns an array that contains the results
     *
     * @param array   the array to map
     * @param fn      a function that accepts each element in the array and
     *                its index and returns a new value to put in its place
     *                in the new array
     *
     * @return newArray the new array created with the results from calling
     *         fn with each element
     */
    function mapWithIndexAndArg(
        MemoryPointer array,
        uint256 arg,
        /* function (uint256 value, uint256 index, uint256 arg) returns (uint256 newValue) */
        function(uint256, uint256, uint256) internal pure returns (uint256) fn
    ) internal pure returns (MemoryPointer newArray) {
        unchecked {
            uint256 length = array.readUint256();

            newArray = malloc((length + 1) * 32);
            newArray.write(length);

            MemoryPointer srcPosition = array.next();
            MemoryPointer srcEnd = srcPosition.offset(length * 0x20);
            MemoryPointer dstPosition = newArray.next();

            uint256 index;
            while (srcPosition.lt(srcEnd)) {
                dstPosition.write(fn(srcPosition.readUint256(), index++, arg));
                srcPosition = srcPosition.next();
                dstPosition = dstPosition.next();
            }
        }
    }

    /**
     * @dev Execute a callback function on each element of an array
     *      and returns an array that contains the results
     *
     * @param array   the array to map
     * @param fn      a function that accepts each element in the array and
     *                `input`, and returns a new value to put in each element's
     *                place in the new array
     *
     * Note:  The `uint256` inputs and output on `fn` are stand-ins as Solidity
     *        has no `any` type. The real callback function should accept the
     *        element type of `array` and the type of `input` and return the
     *        element type of `newArray`.
     *        The function signature should be type-cast for compatibility.
     *
     * @return newArray the new array created with the results from calling
     *         `fn` with each element
     */
    function mapWithTwoInputs(
        MemoryPointer array,
        function(uint256, uint256, uint256) internal pure returns (uint256) fn,
        uint256 input0,
        uint256 input1
    ) internal pure returns (MemoryPointer newArray) {
        unchecked {
            uint256 length = array.readUint256();

            newArray = malloc((length + 1) * 32);
            newArray.write(length);

            MemoryPointer srcPosition = array.next();
            MemoryPointer srcEnd = srcPosition.offset(length * 0x20);
            MemoryPointer dstPosition = newArray.next();

            while (srcPosition.lt(srcEnd)) {
                dstPosition.write(
                    fn(srcPosition.readUint256(), input0, input1)
                );
                srcPosition = srcPosition.next();
                dstPosition = dstPosition.next();
            }
        }
    }
}
