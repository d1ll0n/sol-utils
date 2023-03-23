// pragma solidity ^0.8.19;

// import { ArrayHelpers } from "src/ir-only/ArrayHelpers.sol";
// import { MemoryPointer } from "src/ir-only/MemoryPointer.sol";

// contract ExternalWrapper {
//     ///  @dev map calls a defined callback function on each element of an array
//     ///       and returns an array that contains the results
//     ///  @param array   the array to map
//     ///  @param fn      a function that accepts each element in the array and
//     ///                 returns a new value to put in its place in the new array
//     ///  @return newArray the new array created with the results from calling
//     ///          fn with each element
//     function map(
//         MemoryPointer array,
//         function(uint256) internal pure returns (uint256) fn
//     ) external pure returns (MemoryPointer newArray) {
//         return ArrayHelpers.map(array, fn);
//     }

//     ///  @dev filterMap calls a defined callback function on each element of an array
//     ///       and returns an array that contains only the non-zero results
//     ///  @notice  this method should not be used for arrays with value base types,
//     ///           as it does not shift the head/tail of the array to the appropriate
//     ///           position for such an array
//     ///  @param array   the array to map
//     ///  @param fn      a function that accepts each element in the array and
//     ///                 returns a new value to put in its place in the new array
//     ///                 or a zero value to indicate that the element should not
//     ///                 be included in the new array
//     ///  @return newArray the new array created with the results from calling
//     ///                   fn with each element
//     function filterMap(
//         MemoryPointer array,
//         function(MemoryPointer) internal pure returns (MemoryPointer) fn
//     ) external pure returns (MemoryPointer newArray) {
//         return ArrayHelpers.filterMap(array, fn);
//     }

//     ///  @dev mapWithIndex calls a defined callback function with each element of
//     ///       an array and its index and returns an array that contains the results
//     ///  @param array   the array to map
//     ///  @param fn      a function that accepts each element in the array and
//     ///                 its index and returns a new value to put in its place
//     ///                 in the new array
//     ///  @return newArray the new array created with the results from calling
//     ///          fn with each element
//     function mapWithIndex(
//         MemoryPointer array,
//         function(uint256, uint256) internal pure returns (uint256) fn
//     ) external pure returns (MemoryPointer newArray) {
//         return ArrayHelpers.mapWithIndex(array, fn);
//     }

//     ///  @dev map calls a defined callback function on each element of an array
//     ///       and returns an array that contains the results
//     ///  @param array   the array to map
//     ///  @param arg     an arbitrary value provided in each call to fn
//     ///  @param fn      a function that accepts each element in the array and
//     ///                 the `arg` value provided in the call to map and returns
//     ///                 a new value to put in its place in the new array
//     ///  @return newArray the new array created with the results from calling
//     ///          fn with each element
//     function map(
//         MemoryPointer array,
//         uint256 arg,
//         function(uint256, uint256) internal pure returns (uint256) fn
//     ) external pure returns (MemoryPointer newArray) {
//         return ArrayHelpers.map(array, arg, fn);
//     }

//     function mapWithIndex(
//         MemoryPointer array,
//         uint256 arg,
//         function(uint256, uint256, uint256) internal pure returns (uint256) fn
//     ) external pure returns (MemoryPointer newArray) {
//         return ArrayHelpers.mapWithIndex(array, arg, fn);
//     }

//     function reduce(
//         MemoryPointer array,
//         function(uint256, uint256) internal pure returns (uint256) fn,
//         uint256 initialValue
//     ) external pure returns (uint256 result) {
//         return ArrayHelpers.reduce(array, fn, initialValue);
//     }

//     function reduce(
//         MemoryPointer array,
//         uint256 arg,
//         function(uint256, uint256, uint256) internal pure returns (uint256) fn,
//         uint256 initialValue
//     ) external pure returns (uint256 result) {
//         return ArrayHelpers.reduce(array, arg, fn, initialValue);
//     }

//     function forEach(
//         MemoryPointer array,
//         uint256 arg,
//         function(uint256, uint256) internal pure fn
//     ) external pure {
//         ArrayHelpers.forEach(array, arg, fn);
//     }

//     ///  @dev calls `predicate` once for each element of the array, in ascending order, until it
//     ///       finds one where predicate returns true. If such an element is found, find immediately
//     ///       returns that element value. Otherwise, find returns 0.
//     ///  @custom:author docs shamelessly stolen from TypeScript documentation
//     ///  @param array   array to search
//     ///  @param arg     second input to `predicate`
//     ///  @param predicate function that checks whether each element meets the search filter.
//     ///  @return          the value of the first element in the array where predicate is true
//     ///                   and 0 otherwise.
//     function find(
//         MemoryPointer array,
//         uint256 arg,
//         function(uint256, uint256) internal pure returns (bool) predicate
//     ) external pure returns (uint256) {
//         return ArrayHelpers.find(array, arg, predicate);
//     }

//     ///  @dev calls `predicate` once for each element of the array, in ascending order, until it
//     ///       finds one where predicate returns true. If such an element is found, find immediately
//     ///       returns that element value. Otherwise, find returns 0.
//     ///  @custom:author docs shamelessly stolen from TypeScript documentation
//     ///  @param array     array to search
//     ///  @param predicate function that checks whether each element meets the search filter.
//     ///  @return          the value of the first element in the array where predicate is true
//     ///                   and 0 otherwise.
//     function find(
//         MemoryPointer array,
//         function(uint256) internal pure returns (bool) predicate
//     ) external pure returns (uint256) {
//         return ArrayHelpers.find(array, predicate);
//     }

//     ///  @dev Returns the index of the first occurrence of a value in an array,
//     ///       or -1 if it is not present.
//     ///  @param array         array to search
//     ///  @param searchElement the value to locate in the array.
//     function indexOf(
//         MemoryPointer array,
//         uint256 searchElement
//     ) external pure returns (int256 index) {
//         return ArrayHelpers.indexOf(array, searchElement);
//     }

//     function toInt(bool a) external pure returns (int256 b) {
//         return ArrayHelpers.toInt(a);
//     }

//     function findIndex(
//         MemoryPointer array,
//         uint256 arg,
//         function(uint256, uint256) internal pure returns (bool) predicate
//     ) external pure returns (int256 index) {
//         return ArrayHelpers.findIndex(array, arg, predicate);
//     }
// }
