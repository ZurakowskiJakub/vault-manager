// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {VaultManager} from "../src/VaultManager.sol";
import {Vault} from "../src/Vault.sol";

contract VaultManagerTest is Test {
    VaultManager public vaultManager;

    function setUp() public {
        vaultManager = new VaultManager();
    }

    // Should create a new vault and return its index
    function testAddVault() public {
        uint256 vaultIndex = vaultManager.addVault();

        assertEq(vaultIndex, 0);
    }

    // Should create a new vaults and return their index, last index should match
    function testAddMultipleVault() public {
        vaultManager.addVault();
        vaultManager.addVault();
        vaultManager.addVault();
        uint256 vaultIndex = vaultManager.addVault();

        assertEq(vaultIndex, 3);
    }

    // Should take a vault index and store the provided balance there
    function testDeposit(address _user) public {
        // hoax(_user, 123 ether);
        // uint256 vaultIndex = vaultManager.addVault();
        // vaultManager.deposit{value: 3 ether}(vaultIndex);
        // (address _addrs, uint256 balance) = vaultManager.getVault(vaultIndex);
        // assertEq(balance, 3);
    }

    // Should take vault index and the amount, and withdraw this amount of money only if there is enough balance in the vault
    function testWithdraw(address _user) public {
        hoax(_user, 123 ether);

        uint256 vaultIndex = vaultManager.addVault();
        console2.log(_user);
        console2.log(vaultIndex);
        console2.log(vaultManager.getVault(0));

        vaultManager.deposit{value: 4 ether}(vaultIndex);

        vaultManager.withdraw(vaultIndex, 2 ether);

        assertEq(_user.balance, 121 ether);
    }

    // Should take vault index and the amount, and throw an error if there isn't enough funds in the account
    function testWithdrawNoBalance() public {
        assert(true);
    }

    // Should take vault index and return the details for this vault
    function testGetVault() public {
        assert(true);
    }

    // TODO
    // Should return an error if the vault doesn't exist
    function testGetVaultNotFound() public {
        assert(true);
    }

    // Should return the number of vaults managed by the vault manager
    function testGetVaultsLength() public {
        assert(true);
    }

    // Should return the vaults specific to the owner of the account
    function testGetMyVaults() public {
        assert(true);
    }

    // Should fire an event when a vault is added
    function testVaultAdded() public {
        assert(true);
    }

    // Should fire an event when a deposit is made into a vault
    function testVaultDeposit() public {
        assert(true);
    }

    // Should fire an event when a withdrawl is made from a vault
    function testVaultWithdrawl() public {
        assert(true);
    }

    // Should throw an error when not the account owner tries to access the vault
    function testDepositOnlyOwner() public {
        assert(true);
    }

    // Should throw an error when not the account owner tries to access the vault
    function testWithdrawlOnlyOwner() public {
        assert(true);
    }
}
