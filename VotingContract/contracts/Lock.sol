// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// Import this file to use console.log
import "./interfaces/IVoting.sol";

contract Voting is IVoting {
    mapping(uint256 => Proposal) public proposals;
    uint256 public proposalCount;

    modifier isActive(uint proposalIndex) {
        require(
            proposals[proposalIndex].deadline > block.timestamp,
            "Voting: deadline is ower"
        );
        _;
    }

    function createProposal(string memory _proposal) external {
        Proposal storage prop = proposals[proposalCount];
        prop.proposal = _proposal;
        prop.deadline = block.timestamp + 1 days;
        proposalCount += 1;
    }

    function vote(uint256 _proposalIndex, Vote _vote) external isActive(_proposalIndex) {
        Proposal storage prop = proposals[_proposalIndex];
        if (_vote == Vote.Y) {
            prop.yVotes += 1;
            return;
        }
        prop.nVotes += 1;
    }
}
