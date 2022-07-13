// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
contract Timelock is Ownable {

    uint256 public immutable duration;
    
    uint256 public immutable end;

    constructor(uint256 _duration) {
        duration = _duration;
        end = block.timestamp + duration;
    }

    function deposite(address _token, uint256 _amount) external {
        IERC20(_token).transferFrom(msg.sender, address(this), _amount);
    }

    function withdraw(address _token, uint256 _amount) external onlyOwner {
        require(block.timestamp >= end, "Timelock: lock not finished");
        IERC20(_token).transfer(owner(), _amount); 
    }

}
