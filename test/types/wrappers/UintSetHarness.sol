// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;

import 'src/types/EnumerableSet.sol';
import 'openzeppelin/contracts/utils/structs/EnumerableSet.sol';

contract UintSetHarness {
  UintSet internal _set;

  function indexOf(uint256 value) external view returns (uint256 index) {
    return _set.indexOf(value);
  }

  function length() external view returns (uint256 _length) {
    return _set.length();
  }

  function at(uint256 index) external view returns (uint256 value) {
    return _set.at(index);
  }

  function contains(uint256 value) external view returns (bool) {
    return _set.contains(value);
  }

  function add(uint256 value) external returns (bool result) {
    return _set.add(value);
  }

  function remove(uint256 value) external returns (bool) {
    return _set.remove(value);
  }

  function values() external view returns (uint256[] memory arr) {
    return _set.values();
  }
}

contract UintSetHarnessOZ {
  using EnumerableSet for EnumerableSet.UintSet;

  EnumerableSet.UintSet private _set;

  function indexOf(uint256 value) public view returns (uint256) {
    return _set._inner._indexes[bytes32(value)];
  }

  function length() public view returns (uint256) {
    return _set.length();
  }

  function at(uint256 index) public view returns (uint256) {
    return _set.at(index);
  }

  function contains(uint256 value) public view returns (bool) {
    return _set.contains(value);
  }

  function add(uint256 value) public returns (bool) {
    return _set.add(value);
  }

  function remove(uint256 value) public returns (bool) {
    return _set.remove(value);
  }

  function values() public view returns (uint256[] memory) {
    return _set.values();
  }
}
