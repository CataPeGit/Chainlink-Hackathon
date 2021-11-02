// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";


contract TokenFarm {
    address[] public s_allowedTokens;
    // tokenAddress - > owner -> ballance 
    mapping(address => mapping(address => uint256)) public s_stakingBalance;
    // we want to stake tokens
    // unstake tokens
    // reward users / issue tokens
    function stakeTokens(uint256 amount, address token) public {
        require(amount > 0, "Amount cannot be 0");
        require(tokenIsAllowed(token), "Token isn't allowed");
        // transfer the token from them to this contract
        IERC20(token).transferFrom(msg.sender, address(this), amount);
        s_stakingBalance[token][msg.sender] = s_stakingBalance[token][msg.sender] + amount; 
    }


    function addAllowedTokens(address token) public onlyOwner {
        s_allowedTokens.push(token);
    }


    function tokenIsAllowed(address token) public return(bool) {
        for(uint256 allowedTokensIndex = 0; allowedTokensIndex < s_allowedTokens.length; allowedTokensIndex++){
            if(s_allowedTokens[allowedTokensIndex] == token){
                return true;
            }
        }
        return false;
    }

}
