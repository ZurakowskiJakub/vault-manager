// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {VaultManager} from "../src/VaultManager.sol";

contract VaultManagerTest is Test {
    VaultManager public VaultManager;

    function setUp() public {
        VaultManager = new VaultManager();
        VaultManager.setNumber(0);
    }

    function test_Increment() public {
        VaultManager.increment();
        assertEq(VaultManager.number(), 1);
    }

    function testFuzz_SetNumber(uint256 x) public {
        VaultManager.setNumber(x);
        assertEq(VaultManager.number(), x);
    }
}
