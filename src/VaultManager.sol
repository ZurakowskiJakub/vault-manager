// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Vault} from "./Vault.sol";
import "forge-std/console.sol";

contract VaultManager {
    Vault[] public vaults;
    mapping(address => uint256[]) public vaultsByOwner;

    event VaultAdded(uint256 _id, address owner);
    event VaultDeposit(uint256 _id, address owner, uint256 amount);
    event VaultWithdraw(uint256 _id, address owner, uint256 amount);

    modifier onlyOwner(uint256 vaultIndex) {
        require(
            msg.sender == vaults[vaultIndex].owner,
            "You are not the owner of this vault."
        );
        _;
    }

    function addVault() public returns (uint256) {
        vaults.push(Vault({owner: msg.sender, balance: 0 ether}));
        uint256 index = getVaultsLength() - 1;

        vaultsByOwner[msg.sender].push(index);

        emit VaultAdded(index, msg.sender);
        return index;
    }

    function deposit(uint256 vaultIndex) public payable onlyOwner(vaultIndex) {
        vaults[vaultIndex].balance += msg.value;

        emit VaultDeposit(vaultIndex, msg.sender, msg.value);
    }

    function withdraw(
        uint256 vaultIndex,
        uint256 amount
    ) public onlyOwner(vaultIndex) {
        if (getVault(vaultIndex).balance < amount) {
            revert(
                "You do not have sufficient balance to make this withdrawl."
            );
        }

        address payable to = payable(msg.sender);
        to.transfer(amount);

        vaults[vaultIndex].balance -= amount;

        emit VaultWithdraw(vaultIndex, msg.sender, amount);
    }

    function getVault(uint256 vaultIndex) public view returns (Vault memory) {
        Vault memory vault = vaults[vaultIndex];

        return vault;
    }

    function getVaultsLength() public view returns (uint256) {
        return vaults.length;
    }

    function getMyVaults() public view returns (uint256[] memory) {
        return vaultsByOwner[msg.sender];
    }
}
