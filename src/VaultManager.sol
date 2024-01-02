// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Vault} from "./Vault.sol";

contract VaultManager {
    Vault[] public vaults;
    mapping(address => uint256[]) public vaultsByOwner;

    event VaultAdded(uint256 _id, address owner);
    event VaultDeposit(uint256 _id, address owner, uint256 amount);
    event VaultWithdraw(uint256 _id, address owner, uint256 amount);

    modifier onlyOwner(uint256 vaultIndex) {
        require(msg.sender == vaults[vaultIndex].owner);
        _;
    }

    function addVault(uint256 vaultIndex) public {
        Vault memory newVault = Vault(msg.sender, vaultIndex, 0);
        vaults.push(newVault);

        vaultsByOwner[msg.sender].push(vaultIndex);

        emit VaultAdded(vaultIndex, msg.sender);
    }

    function deposit(uint256 vaultIndex) public payable onlyOwner(vaultIndex) {
        vaults[vaultIndex].balance += msg.value;

        emit VaultDeposit(vaultIndex, msg.sender, msg.value);
    }

    function withdraw(
        uint256 vaultIndex,
        uint256 amount
    ) public onlyOwner(vaultIndex) {
        address payable to = payable(msg.sender);
        to.transfer(amount);

        vaults[vaultIndex].balance -= amount;

        emit VaultWithdraw(vaultIndex, msg.sender, amount);
    }

    function getVault(
        uint256 vaultIndex
    ) public view returns (address, uint256) {
        Vault memory vault = vaults[vaultIndex];
        return (vault.owner, vault.balance);
    }

    function getVaultsLength() public view returns (uint256) {
        return vaults.length;
    }

    function getMyVaults() public view returns (uint256[] memory) {
        return vaultsByOwner[msg.sender];
    }
}
