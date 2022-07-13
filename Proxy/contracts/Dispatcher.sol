//SPDX-License-Identifier: MIT

pragma solidity 0.8.9;

import "./Upgradeable.sol";

contract Dispatcher is Upgradeable {
    constructor (address target) {
        replace(target);
    }

    function initialize() override public pure {
        assert(false);
    }

    fallback() external {
        bytes4 sig;
        assembly { sig := calldataload(0) }
        uint256 len = _sizes[sig];
        address target = _dest;

        assembly {
            calldatacopy(0x0, 0x0, calldatasize())
            let result := delegatecall(sub(gas(), 10000), target, 0x0, calldatasize(), 0, len)
            return (0, len)
        }
    }
}

