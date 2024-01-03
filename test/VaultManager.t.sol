// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {VaultManager} from "../src/VaultManager.sol";
import {Vault} from "../src/Vault.sol";

interface VaultEvents {
    event VaultAdded(uint256 _id, address owner);
    event VaultDeposit(uint256 _id, address owner, uint256 amount);
    event VaultWithdraw(uint256 _id, address owner, uint256 amount);
}

contract VaultManagerTest is Test, VaultEvents {
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
        startHoax(_user, 123 ether);

        uint256 vaultIndex = vaultManager.addVault();

        vaultManager.deposit{value: 3 ether}(vaultIndex);
        Vault memory vault = vaultManager.getVault(vaultIndex);

        vm.stopPrank();

        assertEq(vault.balance, 3 ether);
    }

    // Should take vault index and the amount, and withdraw this amount of money only if there is enough balance in the vault
    function testWithdraw(address _user) public {
        startHoax(_user, 123 ether);

        uint256 vaultIndex = vaultManager.addVault();

        vaultManager.deposit{value: 4 ether}(vaultIndex);
        vaultManager.withdraw(vaultIndex, 2 ether);

        vm.stopPrank();

        assertEq(_user.balance, 121 ether);
    }

    // Should take vault index and the amount, and throw an error if there isn't enough funds in the account
    function testWithdrawNoBalance(address _user) public {
        startHoax(_user, 123 ether);

        uint256 vaultIndex = vaultManager.addVault();

        vaultManager.deposit{value: 4 ether}(vaultIndex);

        vm.expectRevert(
            "You do not have sufficient balance to make this withdrawl."
        );
        vaultManager.withdraw(vaultIndex, 6 ether);

        vm.stopPrank();
    }

    // Should take vault index and return the details for this vault
    function testGetVault(address _user) public {
        startHoax(_user);

        uint256 vaultIndex = vaultManager.addVault();

        Vault memory vault = vaultManager.getVault(vaultIndex);

        vm.stopPrank();

        assertEq(_user, vault.owner);
        assertEq(0 ether, vault.balance);
    }

    // Should return the number of vaults managed by the vault manager
    function testGetVaultsLength(uint8 randNo) public {
        for (uint8 i = 0; i < randNo; i++) {
            vaultManager.addVault();
        }

        uint256 len = vaultManager.getVaultsLength();

        assertEq(len, randNo);
    }

    // Should return the vaults specific to the owner of the account
    function testGetMyVaults(address _user, uint8 randNo) public {
        startHoax(_user);

        for (uint8 i = 0; i < randNo; i++) {
            vaultManager.addVault();
        }

        uint256[] memory vaults = vaultManager.getMyVaults();

        vm.stopPrank();

        assertEq(randNo, vaults.length);
    }

    // Should fire an event when a vault is added
    function testVaultAdded(address _user) public {
        startHoax(_user);

        vm.expectEmit(true, true, false, true);
        emit VaultAdded(0, _user);

        vaultManager.addVault();

        vm.stopPrank();
    }

    // Should fire an event when a deposit is made into a vault
    function testVaultDeposit(address _user) public {
        startHoax(_user, 123 ether);

        vaultManager.addVault();

        vm.expectEmit(true, true, false, true);
        emit VaultDeposit(0, _user, 0.69 ether);

        vaultManager.deposit{value: 0.69 ether}(0);

        vm.stopPrank();
    }

    // Should fire an event when a withdrawl is made from a vault
    function testVaultWithdrawl(address _user) public {
        startHoax(_user, 123 ether);

        vaultManager.addVault();
        vaultManager.deposit{value: 0.69 ether}(0);

        vm.expectEmit(true, true, false, true);
        emit VaultWithdraw(0, _user, 0.69 ether);

        vaultManager.withdraw(0, 0.69 ether);

        vm.stopPrank();
    }

    // Should throw an error when not the account owner tries to access the vault
    function testDepositOnlyOwner(address owner, address notOwner) public {
        vm.prank(owner);
        uint256 vaultIndex = vaultManager.addVault();

        hoax(notOwner, 123 ether);
        vm.expectRevert("You are not the owner of this vault.");
        vaultManager.deposit{value: 5 ether}(vaultIndex);
    }

    // Should throw an error when not the account owner tries to access the vault
    function testWithdrawlOnlyOwner(address owner, address notOwner) public {
        startHoax(owner, 123 ether);
        uint256 vaultIndex = vaultManager.addVault();
        vaultManager.deposit{value: 5 ether}(vaultIndex);
        vm.stopPrank();

        hoax(notOwner, 123 ether);
        vm.expectRevert("You are not the owner of this vault.");
        vaultManager.withdraw(vaultIndex, 5 ether);
    }
}
