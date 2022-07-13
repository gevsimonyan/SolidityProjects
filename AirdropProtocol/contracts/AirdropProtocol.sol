// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "./interfaces/IAirdropProtocol.sol";

contract AirdropProtocol is IAirdropProtocol {
    function airdropERC1155(
        IERC1155 _token,
        address[] calldata _to,
        uint256[] calldata _amount,
        uint256[] calldata _id
    ) external {
        require(_to.length == _id.length, "AirdropProtocol: wrong arrs lenght");
        for (uint256 i = 0; i < _id.length; i++) {
            _token.safeTransferFrom(msg.sender, _to[i], _id[i], _amount[i], "");
        }
    }

    function airdropERC721(
        IERC721 _token,
        address[] calldata _to,
        uint256[] calldata _id
    ) external {
        require(_to.length == _id.length, "AirdropProtocol: wrong arrs lenght");
        for (uint256 i = 0; i < _id.length; i++) {
            _token.safeTransferFrom(msg.sender, _to[i], _id[i]);
        }
    }

    function airdropERC20(
        IERC20 _token,
        address[] calldata _to,
        uint256[] calldata _value
    ) external {
        require(
            _to.length == _value.length,
            "AirdropProtocol: wrong arrs lenght"
        );
        for (uint256 i = 0; i < _to.length; i++) {
            _token.transferFrom(msg.sender, _to[i], _value[i]);
        }
    }
}
