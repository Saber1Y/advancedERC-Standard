// SPDX-License-Identifier: MIT
pragma solidity ^0.8.33;

import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Pausable} from "@openzeppelin/contracts/utils/Pausable.sol";
import {ERC20Permit} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";

error NotMinter();

contract AdvancedERCToken is ERC20, AccessControl, Pausable, ERC20Permit {

  bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
  bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");

   constructor() ERC20("AdvancedToken", "ATK") ERC20Permit("AdvancedToken") {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(MINTER_ROLE, msg.sender);
        _grantRole(PAUSER_ROLE, msg.sender);

        _mint(msg.sender, 1_000_000 ether);
    }

    function mint(address to, uint256 amount) public onlyRole(MINTER_ROLE) {
        if (!hasRole(MINTER_ROLE, msg.sender)) {
            revert NotMinter();
        }
        _mint(to, amount);
    }

    function burn(uint256 amount) public onlyRole(MINTER_ROLE) {
        if (!hasRole(MINTER_ROLE, msg.sender)) {
            revert NotMinter();
        }
        
        _burn(msg.sender, amount);
    }

}