// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./PointerLibraries.sol";

library ArrayHelpers {
    /**
     * @dev filter calls a defined callback function on each element of an array
     *      and returns an array that contains only the elements which the callback
     *      returned true for
     *
     * @notice  this method should not be used for arrays with value base types,
     *          as it does not shift the head/tail of the array to the appropriate
     *          position for such an array
     *
     * @param array   the array to map
     * @param fn      a function that accepts each element in the array and
     *                returns a boolean that indicates whether the element
     *                should be included in the new array
     *
     * @return newArray the new array created with the elements which the callback
     *                  returned true for
     */
    function filter(
        MemoryPointer array,
        /* function (uint256 value) returns (bool) */
        function(MemoryPointer) internal pure returns (bool) fn
    ) internal pure returns (MemoryPointer newArray) {
        unchecked {
            uint256 length = array.readUint256();

            newArray = malloc((length + 1) * 32);

            MemoryPointer srcPosition = array.next();
            MemoryPointer srcEnd = srcPosition.offset(length * 0x20);
            MemoryPointer dstPosition = newArray.next();

            length = 0;

            while (srcPosition.lt(srcEnd)) {
                MemoryPointer element = srcPosition.readMemoryPointer();
                if (fn(element)) {
                    dstPosition.write(element);
                    dstPosition = dstPosition.next();
                    length += 1;
                }
                srcPosition = srcPosition.next();
            }
            newArray.write(length);
        }
    }
}
