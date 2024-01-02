// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {VaultManager} from "../src/VaultManager.sol";

contract VaultManagerTest is Test {
    VaultManager public vaultManager;

    function setUp() public {
        vaultManager = new VaultManager();
    }

    // function testAddVault() public {
    //     uint256 index = vaultManager.addVault();

    //     assertEq(index, 0);
    //     assertEq(vaultManager.getVaultsLength(), 1);
    //     assertEq(vaultManager.vaults[0].owner, msg.sender);
    // }

    function testGetVault(uint256 x) public {
        uint256 index = vaultManager.addVault();
        assertEq(vaultManager.getVault(index), Vault(msg.sender, 0));
    }
}
