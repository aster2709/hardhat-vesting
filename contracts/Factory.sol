//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.7.3;
import {TokenVesting} from './Vesting.sol';

contract Factory {
    TokenVesting tokenVesting;

    mapping (address => address) public userToVesting;

    address[] public vestings;
    
    function createVestingInstance(uint[] memory periods, uint[] memory amounts, address beneficiary,address token, address owner) external {
        require(periods.length >= 1 && periods.length == amounts.length, 'wrong params');
        require(beneficiary != address(0) && token != address(0) && owner != address(0), 'null address');
        require(userToVesting[beneficiary] == address(0), "You can only have one vesting contract");
        tokenVesting = new TokenVesting(periods, amounts, beneficiary, token, owner);
        userToVesting[beneficiary] = address(tokenVesting);
        vestings.push(address(tokenVesting));
    }
}