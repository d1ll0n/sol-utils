import "./ArrayHelpers.sol";
import "forge-std/console2.sol";

contract TestArray/*  is Test */ {
  using ArrayHelpers for MemoryPointer;

  function toPtr(uint256[] memory arr) internal pure returns (MemoryPointer ptr) {
    assembly {
      ptr := arr
    }
  }

  function toArr(MemoryPointer ptr) internal pure returns (uint256[] memory arr) {
    assembly {
      arr := ptr
    }
  }

  function double(uint256 x) internal pure returns (uint256 y) {
     assembly {
       y := mul(x, 2)
     }
  }
  
  modifier logsGas {
    uint256 startGas = gasleft();
    _;
    console2.log("Gas used: ", startGas - gasleft());
  }

  function doubleArrayElements(uint256[] memory arr) internal pure returns (uint256[] memory doubled) {
 /*    assembly {
      let length := mload(arr)
      doubled := mload(0x40)
      // mstore(0x40, add(doubled, add(shl(length, 5), 0x20)))
      mstore(doubled, length)
      let srcPosition := add(arr, 0x20)
      let srcEnd := add(srcPosition, mul(length, 0x20))
      let dstPosition := add(doubled, 0x20)
      for { } lt(srcPosition, srcEnd) { } {
        mstore(dstPosition, mul(mload(srcPosition), 2))
        dstPosition := add(dstPosition, 0x20)
        srcPosition := add(srcPosition, 0x20)
      }
      mstore(0x40, dstPosition)
    } */
    doubled = toArr(toPtr(arr).map2(double));
  }

  function test() external/*  view returns (uint256) */ {
    uint256[] memory arr = new uint256[](3);
    arr[0] = 1;
    arr[1] = 2;
    arr[2] = 3;
    // MemoryPointer ptr = toPtr(arr);
    //ptr.map = 809
    //ptr.map2 = 806
    // uint256 length = arr.length;
    // uint256[] memory doubled = new uint256[](length);
    /* unchecked { cost = 1388
      for (uint256 i; i < length; i++) {
        doubled[i] = double(arr[i]);
      }
    } */
    // uint256[] memory doubled = toArr(toPtr(arr).map2(double));
    uint256[] memory doubled = doubleArrayElements(arr);
    // assembly {
    //   let length := mload(arr)
    //   doubled := mload(0x40)
    //   mstore(0x40, add(doubled, mul(add(length, 1), 0x20)))
    //   mstore(doubled, length)
    //   let srcPosition := add(arr, 0x20)
    //   let srcEnd := add(srcPosition, mul(length, 0x20))
    //   let dstPosition := add(doubled, 0x20)
    //   for { } lt(srcPosition, srcEnd) { } {
    //     mstore(dstPosition, mul(mload(srcPosition), 2))
    //     srcPosition := add(srcPosition, 0x20)
    //     dstPosition := add(dstPosition, 0x20)
    //   }
    // }
    // return doubled[0];
  }
}