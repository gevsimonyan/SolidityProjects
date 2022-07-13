//SPDX-License-Identifier: Unlicense
pragma solidity 0.8.7;

contract MemoryTest {

    function getFunctionSelector(string memory _signature) public returns(bytes4) {
        // signature example
        // _signature = "getStringMemory(string)"
        return bytes4(keccak256(bytes(_signature)));
    }

    function getStringMemory(string memory _str) public returns(bytes32 data) {
        assembly {
            let ptr := mload(0x40)
            data := mload(sub(ptr, 32))
        }
    }

    function getFixArrMemory(uint[3] memory _arr) public returns(bytes32 el1, bytes32 el2, bytes32 el3) {
        assembly {
            let ptr := mload(0x40)
            el1 := mload(sub(ptr, 96))
            el2 := mload(sub(ptr, 64))
            el3 := mload(sub(ptr, 32))
        }
    }

    function msgDataReturn(uint[3] memory _arr) public returns(bytes memory) {
        return msg.data;
    }

    function getFixArrayCalldata(uint[3] calldata _arr) public returns(bytes32 _el1) {
        assembly {
            // start reading from 4 byte, because first 4 bytes take function selector
            _el1 := calldataload(4)
        }
    }

    function getStringCallData(string calldata _str) public returns(
        bytes32 lengthToOurString, bytes32 bytes32Size, bytes32 data
        ) {
        assembly {
            lengthToOurString := calldataload(4) // 20
            // we must add 32 to get string
            bytes32Size := calldataload(add(4, 32)) // 4
            // 4 is length of our bytes32 memory word
            data := calldataload(add(4, 64))
        }
    }

    function getDynamicArrCalldata(uint[] calldata _arr) public returns(
        bytes32 _startIn, bytes32 _elCount, bytes32 _fisrtElem, bytes32 _secondElem, bytes32 _thirdElem
        ) {
        assembly {
            _startIn := calldataload(4)
            _elCount := calldataload(add(_startIn, 4))
            _fisrtElem := calldataload(add(_startIn, 36))
            _secondElem := calldataload(add(_startIn, 68))
            _thirdElem := calldataload(add(_startIn, 100))
        }
    }
}