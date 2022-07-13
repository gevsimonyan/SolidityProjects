// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;


import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";

interface IAirdropProtocol {
    function airdropERC1155(IERC1155, address[] calldata, uint256[] calldata, uint256[] calldata) external;
    function airdropERC721(IERC721, address[] calldata, uint256[] calldata) external;
    function airdropERC20(IERC20, address[] calldata, uint256[] calldata) external;
}
