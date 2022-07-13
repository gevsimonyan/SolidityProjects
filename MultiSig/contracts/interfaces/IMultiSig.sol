// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

interface IMultiSig {
    struct TX {
        address to;
        uint256 value;
        bytes data;
        bool isExecuted;
        uint256 numConfirm;
    }

    event Confirm(address indexed onwer, uint256 indexed txIndex);
    event Revoke(address indexed onwer, uint256 indexed txIndex);
    event Execute(address indexed onwer, uint256 indexed txIndex);

    event Deposit(address indexed sender, uint256 amount, uint256 balance);
    event Sumbit(
        address indexed owner,
        uint256 indexed txIndex,
        address indexed to,
        uint256 value,
        bytes data
    );

    function getTransaction(uint256)
        external
        view
        returns (
            address,
            uint256,
            bytes memory,
            bool,
            uint256
        );

    function submitTx(
        address,
        uint256,
        bytes memory
    ) external;

    function confirmTx(uint256) external;

    function execTx(uint256) external;

    function revokeTx(uint) external;
}
