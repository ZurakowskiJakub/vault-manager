// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {VaultManager} from "../src/VaultManager.sol";

contract VaultManagerTest is Test {
    VaultManager public vaultManager;

    function setUp() public {
        vaultManager = new VaultManager();
    }

    function testAddVault() public {
        uint256 index = vaultManager.addVault();

        assertEq(index, 0);
        assertEq(vaultManager.vaults.length, 1);
        assertEq(vaultManager.vaultsByOwner[msg.sender].length, 1);
    }

    // function testFuzz_SetNumber(uint256 x) public {
    //     vaultManager.setNumber(x);
    //     assertEq(vaultManager.number(), x);
    // }
}
