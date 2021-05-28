//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.7.3;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract DummyToken is ERC20 {
    constructor() ERC20('DummyToken', 'DMT') {}
    function mint(uint amount) external {
        _mint(msg.sender, amount * 10 ** decimals() );
    }
}




