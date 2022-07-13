// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "./interfaces/IMultiSig.sol";

contract MultiSig is IMultiSig {
    address[] public onwers;
    mapping(address => bool) public isOwner;
    uint256 public requiredOnwers;

    TX[] public txs;

    mapping(uint256 => mapping(address => bool)) public isConfirmed; // tx index -> owner -> bool

    constructor(address[] memory _owners, uint256 _requiredOwners) {
        require(_owners.length > 0, "MultiSig: require min 1 owner");
        require(
            _requiredOwners > 0 && requiredOnwers <= _owners.length,
            "MultiSig: wrong owners amount"
        );

        for (uint256 i = 0; i < _owners.length; i++) {
            require(_owners[i] != address(0), "MultiSig: invalid address");
            require(!isOwner[_owners[i]], "MultiSig: owner must be uniqie");
            isOwner[_owners[i]] = true;
            onwers.push(_owners[i]);
        }

        requiredOnwers = _requiredOwners;
    }

    modifier onlyOwner() {
        require(isOwner[msg.sender], "MultiSig: Only owner");
        _;
    }

    modifier notConfirmed(uint256 txIndex) {
        require(
            !isConfirmed[txIndex][msg.sender],
            "MultiSig: already confirmed tx"
        );
        _;
    }

    modifier notExecuted(uint256 txIndex) {
        require(!txs[txIndex].isExecuted, "MultiSig: tx already executed");
        _;
    }

    modifier txExists(uint256 txIndex) {
        require(txIndex < txs.length, "MultiSig: tx doesn't exist");
        _;
    }

    function getTransaction(uint256 txIndex)
        public
        view
        returns (
            address to,
            uint256 value,
            bytes memory data,
            bool isExecuted,
            uint256 numConfirm
        )
    {
        TX memory _tx = txs[txIndex];

        return (_tx.to, _tx.value, _tx.data, _tx.isExecuted, _tx.numConfirm);
    }

    function submitTx(
        address _to,
        uint256 _value,
        bytes memory _data
    ) public onlyOwner {
        uint256 txIndex = txs.length;
        txs.push(TX(_to, _value, _data, false, 0));

        emit Sumbit(msg.sender, txIndex, _to, _value, _data);
    }

    function confirmTx(uint256 _txIndex)
        public
        onlyOwner
        txExists(_txIndex)
        notConfirmed(_txIndex)
        notExecuted(_txIndex)
    {
        TX storage _tx = txs[_txIndex];
        _tx.numConfirm += 1;
        isConfirmed[_txIndex][msg.sender] = true;
        emit Confirm(msg.sender, _txIndex);
    }

    function execTx(uint256 _txIndex)
        public
        onlyOwner
        txExists(_txIndex)
        notExecuted(_txIndex)
    {
        TX storage _tx = txs[_txIndex];
        require(
            _tx.numConfirm >= requiredOnwers,
            "MultiSig: Not enough confirms"
        );
        _tx.isExecuted = true;
        emit Execute(msg.sender, _txIndex);
    }

    function revokeTx(uint _txIndex)
        public
        onlyOwner
        txExists(_txIndex)
        notExecuted(_txIndex)
    {
        TX storage _tx = txs[_txIndex];
        require(
            isConfirmed[_txIndex][msg.sender],
            "MultiSig: tx not confirmed"
        );

        _tx.numConfirm -= 1;
        isConfirmed[_txIndex][msg.sender] = false;

        emit Revoke(msg.sender, _txIndex);
    }
}
