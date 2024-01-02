// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {VaultManager} from "../src/VaultManager.sol";

contract VaultManagerTest is Test {
    VaultManager public vaultManager;

    // function setUp() public {
    //     vaultManager = new VaultManager();
    //     vaultManager.setNumber(0);
    // }

    // function test_Increment() public {
    //     vaultManager.increment();
    //     assertEq(vaultManager.number(), 1);
    // }

    // function testFuzz_SetNumber(uint256 x) public {
    //     vaultManager.setNumber(x);
    //     assertEq(vaultManager.number(), x);
    // }
}
