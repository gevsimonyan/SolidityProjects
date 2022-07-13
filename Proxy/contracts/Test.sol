//SPDX-License-Identifier: MIT

pragma solidity 0.8.9;

import "./Upgradeable.sol";

contract Test is Upgradeable {
    uint256 _value;

    function initialize() public override {
        _sizes[bytes4(keccak256("getUint()"))] = 32;
    }

    function getUint() public view returns (uint) {
        return _value;
    }

    function setUint(uint value) public {
        _value = value;
    }
}
