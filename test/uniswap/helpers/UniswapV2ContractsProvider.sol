// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import { Vm } from "forge-std/Vm.sol";

import "src/uniswap/interfaces/IUniswapV2Router.sol";
import "src/uniswap/interfaces/IUniswapV2Factory.sol";

contract UniswapV2ContractsProvider {
    address private constant VM_ADDRESS =
        address(uint160(uint256(keccak256("hevm cheat code"))));

    Vm private constant vm = Vm(VM_ADDRESS);

    IUniswapV2Router internal constant uniswapV2Router =
        IUniswapV2Router(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);

    IUniswapV2Factory internal constant uniswapV2Factory =
        IUniswapV2Factory(0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f);

    constructor() {
        bytes memory factoryCode = vm.getDeployedCode(
            "./external/UniswapV2Factory.json"
        );
        vm.etch(address(uniswapV2Factory), factoryCode);
        bytes memory routerCode = vm.getDeployedCode(
            "./external/UniswapV2Router02.json"
        );
        vm.etch(address(uniswapV2Router), routerCode);
    }
}
