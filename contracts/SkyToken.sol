// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.5;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract SkyToken is ERC20 {

    address public tokenAdmin;
    uint256 public maxSupply = 1500000000;
    constructor() ERC20("Sky Token","SKY"){
        tokenAdmin = msg.sender;
    }
    function leftSupply() view public returns(uint256) {
        return maxSupply - totalSupply();
    }
    function mint(address to, uint256 amount) external {
        require(maxSupply > (totalSupply()+amount),"Maximun supply for SkyToken reached. Cannot mint any more tokens."); 
        _mint(to, amount);
    }
    function burn(uint amount) external {
        _burn(msg.sender, amount);
    }
}


