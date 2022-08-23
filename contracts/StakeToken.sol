// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
import "OpenZeppelin/openzeppelin-contracts@4.4.2/contracts/token/ERC20/ERC20.sol";

contract StakeToken is ERC20 {
    constructor(address mintAddress, uint256 totalMint)
        ERC20("StakeToken", "ST")
    {
        _mint(mintAddress, totalMint);
    }
}
