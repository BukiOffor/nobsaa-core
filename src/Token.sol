// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";


contract Token is ERC20, ERC20Permit {
    address immutable caller;
    
    constructor(uint256 initialSupply) ERC20("Liquidity Provider", "LP")ERC20Permit("Liquidity Provider") {
        _mint(msg.sender, initialSupply);
        caller = msg.sender;
    }


}
