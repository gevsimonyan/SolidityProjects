// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

interface IVoting {
    struct Proposal {
        string proposal;
        uint256 deadline;
        uint256 yVotes;
        uint256 nVotes;
        bool isExecuted;
        mapping(address => bool) voters;
    }

    enum Vote { Y, N } // Y = 0, N = 1

    event CreateProposal(string indexed proposal);

    function createProposal(string memory) external ;

    function vote(uint256, Vote) external;
}