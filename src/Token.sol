// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";

contract Token is ERC20, ERC20Permit {
    address immutable caller;

    bool votingInProgress = false;

    constructor() ERC20("Nobsaa Governance Token", "NGT") ERC20Permit("Nobsaa Governance Token") {
        caller = msg.sender;
    }

    function mint(address to, uint256 amount) public {
        require(msg.sender == caller, "Only the caller can mint");
        _mint(to, amount);
    }

    function initateVoting() public {
        require(msg.sender == caller, "Only the caller can start voting");
        votingInProgress = true;
    }

    function endVoting() public {
        require(msg.sender == caller, "Only the caller can end voting");
        votingInProgress = false;
    }

    function burn(address from, uint256 amount) external {
        require(msg.sender == caller, "Only the caller can burn");
        _burn(from, amount);
    }

    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        require(votingInProgress == false, "Voting in progress");
        return super.transfer(recipient, amount);
    }

    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
        require(votingInProgress == false, "Voting in progress");
        return super.transferFrom(sender, recipient, amount);
    }

    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        require(votingInProgress == false, "Voting in progress");
        return super.approve(spender, amount);
    }
}
