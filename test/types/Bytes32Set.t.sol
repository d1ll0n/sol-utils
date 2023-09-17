// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;

import 'forge-std/Test.sol';
import './wrappers/Bytes32SetHarness.sol';

bytes32 constant ValueA = 0xdeadbeef00000000000000000000000000000000000000000000000000000000;
bytes32 constant ValueB = 0x0123456789000000000000000000000000000000000000000000000000000000;
bytes32 constant ValueC = 0x4242424200000000000000000000000000000000000000000000000000000000;

abstract contract BaseEnumerableSetTest is Test {
  ISet internal _set;
  bytes internal ArrayOutOfBoundsError =
    abi.encodePacked(bytes4(bytes32(Panic_ErrorSelector << 224)), Panic_ArrayOutOfBounds);

  function assertEq(bytes32[] memory a, bytes32[] memory b) internal virtual {
    uint256[] memory _a;
    uint256[] memory _b;
    assembly {
      _a := a
      _b := b
    }
    assertEq(_a, _b);
  }

  function membersMatch(bytes32[] memory values) internal {
    assertEq(_set.length(), values.length);
    for (uint256 i; i < values.length; i++) {
      assertTrue(_set.contains(values[i]));
      assertEq(_set.at(i), values[i]);
      assertEq(_set.indexOf(values[i]), i + 1);
    }
    assertEq(_set.values(), values);
  }

  function testStartsEmpty() external {
    assertFalse(_set.contains(ValueA));
    membersMatch(new bytes32[](0));
  }

  function testAddOneValue() external {
    assertTrue(_set.add(ValueA));
    bytes32[] memory arr = new bytes32[](1);
    arr[0] = ValueA;
    membersMatch(arr);
  }

  function testAddTwoValues() external {
    assertTrue(_set.add(ValueA));
    assertTrue(_set.add(ValueB));
    bytes32[] memory arr = new bytes32[](2);
    arr[0] = ValueA;
    arr[1] = ValueB;
    membersMatch(arr);
    assertFalse(_set.contains(ValueC));
  }

  function testAddExistingValue() external {
    assertTrue(_set.add(ValueA));
    assertFalse(_set.add(ValueA));
  }

  function testAtRevertsForNonExistentElements() external {
    vm.expectRevert(ArrayOutOfBoundsError);
    _set.at(0);
  }

  function testRemoveOneValue() external {
    assertTrue(_set.add(ValueA));
    assertTrue(_set.remove(ValueA));
    membersMatch(new bytes32[](0));
    assertFalse(_set.contains(ValueA));
  }

  function testRemoveNonExistentValue() external {
    assertFalse(_set.remove(ValueA), "remove nonexistent not false");
  }

  function testAddAndRemoveMultipleValues() external {
    // []

    assertTrue(_set.add(ValueA));
    assertTrue(_set.add(ValueC));
    // [A, C]

    assertTrue(_set.remove(ValueA));
    assertFalse(_set.remove(ValueB));
    // [C]

    assertTrue(_set.add(ValueB));
    // [C, B]

    assertTrue(_set.add(ValueA));
    // [C, B, A]

    assertTrue(_set.remove(ValueC));
    // [A, B]

    assertFalse(_set.add(ValueA));
    assertFalse(_set.add(ValueB));
    // [A, B]

    assertTrue(_set.add(ValueC));
    // [A, B, C]

    assertTrue(_set.remove(ValueA));
    // [C, B]

    assertTrue(_set.add(ValueA));
    // [C, B, A]

    assertTrue(_set.remove(ValueB));

    // [C, A]

    bytes32[] memory arr = new bytes32[](2);
    arr[0] = ValueC;
    arr[1] = ValueA;
    membersMatch(arr);

    assertFalse(_set.contains(ValueB));
  }
}

contract EnumerableSetTest is BaseEnumerableSetTest {
  function setUp() external {
    _set = ISet(address(new Bytes32SetHarness()));
  }
}

contract OZEnumerableSetTest is BaseEnumerableSetTest {
  function setUp() external {
    _set = ISet(address(new Bytes32SetHarnessOZ()));
  }
}

interface ISet {
  function indexOf(bytes32 value) external view returns (uint256);

  function length() external view returns (uint256);

  function at(uint256 index) external view returns (bytes32);

  function contains(bytes32 value) external view returns (bool);

  function add(bytes32 value) external returns (bool);

  function remove(bytes32 value) external returns (bool);

  function values() external view returns (bytes32[] memory);
}
