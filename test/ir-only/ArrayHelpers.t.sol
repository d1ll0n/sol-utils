// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "src/ir-only/ArrayHelpers.sol";

contract ArrayHelpersTest is Test {
    ArrayHelperWrapper internal wrapper;

    function setUp() public {
        wrapper = new ArrayHelperWrapper();
    }

    function testFilterMap() external {
        SomeData[] memory arr = new SomeData[](10);
        for (uint256 i; i < 10; i++) {
            arr[i] = SomeData(i * 100);
        }
        SomeData[] memory arrOut = wrapper.filterMap(arr);
        assertEq(arrOut.length, 8);
        for (uint256 i; i < 8; i++) {
            assertEq(arrOut[i].value, (i + 2) * 200);
        }
    }

    function testIncludes() external {
        uint256[] memory arr = new uint256[](10);
        for (uint256 i; i < 10; i++) {
            arr[i] = i * 100;
        }
        assertTrue(wrapper.includes(arr, 0));
        assertTrue(wrapper.includes(arr, 100));
        assertTrue(wrapper.includes(arr, 900));
        assertFalse(wrapper.includes(arr, 1));
    }
}

struct SomeData {
    uint256 value;
}

contract ArrayHelperWrapper {
    function filterMap(
        SomeData[] memory arr
    ) external pure returns (SomeData[] memory) {
        return
            withSomeDataArrayTypes(ArrayHelpers.filterMap)(
                arr,
                getValuesOver100
            );
    }

    // =====================================================================//
    //                      includes with one argument                      //
    // =====================================================================//

    function includes(
        uint256[] memory arr,
        uint256 value
    ) external pure returns (bool) {
        return ArrayHelpers.includes($(arr), value);
    }

    function $(uint256[] memory arr) internal pure returns (MemoryPointer ptr) {
        assembly {
            ptr := arr
        }
    }

    function toMemoryPointer(
        SomeData memory data
    ) internal pure returns (MemoryPointer ptr) {
        assembly {
            ptr := data
        }
    }

    function toArray(
        MemoryPointer ptr
    ) internal pure returns (SomeData[] memory arr) {
        assembly {
            arr := ptr
        }
    }

    function getValuesOver100(
        SomeData memory data
    ) internal pure returns (MemoryPointer) {
        if (data.value > 100) {
            return toMemoryPointer(SomeData(data.value * 2));
        }
    }

    function withSomeDataArrayTypes(
        function(
            MemoryPointer,
            function(MemoryPointer) internal pure returns (MemoryPointer)
        ) internal pure returns (MemoryPointer) fnIn
    )
        internal
        pure
        returns (
            function(
                SomeData[] memory,
                function(SomeData memory) internal pure returns (MemoryPointer)
            ) internal pure returns (SomeData[] memory) fnOut
        )
    {
        assembly {
            fnOut := fnIn
        }
    }
}
