contract Token {
  function balanceOf(address) external view returns (uint256) {
      return 5000;
  }
}



    //   /**
    //    * @dev filterMap calls a defined callback function on each element of an array
    //    *      and returns an array that contains only the non-zero results
    //    *
    //    *  doubleFilterMapWithArg = (arr1, arr2, predicate, arg) => [...arr1, ...arr2]
    //    *    .map((element) => predicate(element, arg))
    //    *    .filter(result => result != 0)
    //    *
    //    * @param array1  the first array to map
    //    * @param array2  the second array to map
    //    * @param fn      a function that accepts each element in the array and
    //    *                returns a new value to put in its place in the new array
    //    *                or a zero value to indicate that the element should not
    //    *                be included in the new array
    //    * @param arg     an arbitrary value provided in each call to fn
    //    *
    //    * @return newArray the new array created with the results from calling
    //    *                  fn with each element
    //    */
    //   function doubleFilterMapWithArg(
    //     MemoryPointer array1,
    //     MemoryPointer array2,
    //     /* function (MemoryPointer element, MemoryPointer arg) returns (uint256 newValue) */
    //     function(MemoryPointer, MemoryPointer) internal pure returns (MemoryPointer) fn,
    //     MemoryPointer arg
    // ) internal pure returns (MemoryPointer newArray) {
    //     unchecked {
    //         uint256 length1 = array1.readUint256();
    //         uint256 length2 = array2.readUint256();

    //         newArray = malloc((length + 1) * 32);
    //         MemoryPointer dstPosition = newArray.next();

    //         MemoryPointer srcPosition = array.next();
    //         MemoryPointer srcEnd = srcPosition.offset(length * 0x20);

    //         length = 0;

    //         while (srcPosition.lt(srcEnd)) {
    //             MemoryPointer result = fn(srcPosition.readMemoryPointer(), arg);
    //             if (!result.isNull()) {
    //                 dstPosition.write(result);
    //                 dstPosition = dstPosition.next();
    //                 length += 1;
    //             }
    //             srcPosition = srcPosition.next();
    //         }
    //         newArray.write(length);
    //     }
    // }