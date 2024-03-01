// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

//import "zk-merkle-tree/contracts/ZKTree.sol";
import "./zk-merkle-tree/contracts/ZKTree.sol";

contract ZKTreeVote is ZKTree {
//    owner 变量，用于存储合约所有者的地址。
    address public owner;
//    validators 映射，用于存储一个布尔值，表示一个地址是否为验证者。
    mapping(address => bool) public validators;
//    uniqueHashes 映射，用于存储一个布尔值，表示一个唯一哈希是否已被使用。
    mapping(uint256 => bool) uniqueHashes;
//    numOptions 变量，用于存储投票选项的数量。
    uint numOptions;
//    optionCounter 映射，用于存储每个选项的投票计数。
    mapping(uint => uint) optionCounter;

//    定义了构造函数，用于初始化合约。它接受级别数、哈希器合约、验证器合约和投票选项数量作为参数。
//    设置了合约所有者，初始化了 optionCounter 映射，并设置了合约的选项数量。
    constructor(
        uint32 _levels,
        IHasher _hasher,
        IVerifier _verifier,
        uint _numOptions
    ) ZKTree(_levels, _hasher, _verifier) {
        owner = msg.sender;
        numOptions = _numOptions;
        for (uint i = 0; i <= numOptions; i++) optionCounter[i] = 0;
    }

//  定义了 registerValidator 函数，允许合约所有者注册验证者。只有合约所有者可以调用此函数。
    function registerValidator(address _validator) external {
        require(msg.sender == owner, "Only owner can add validator!");
        validators[_validator] = true;
    }

//    定义了 registerCommitment 函数，允许验证者注册他们的承诺。它接受一个唯一哈希和一个承诺作为参数。
//    只有验证者可以调用此函数，并且唯一哈希必须尚未被使用。该函数调用了 ZKTree 合约中的 _commit 函数，并将唯一哈希标记为已使用。
    function registerCommitment(
        uint256 _uniqueHash,
        uint256 _commitment
    ) external {
        require(validators[msg.sender], "Only validator can commit!");
        require(
            !uniqueHashes[_uniqueHash],
            "This unique hash is already used!"
        );
        _commit(bytes32(_commitment));
        uniqueHashes[_uniqueHash] = true;
    }

//    定义了 vote 函数，允许用户进行投票。它接受投票选项、空化器、根哈希和零知识证明参数。
//    函数检查选项是否有效，调用了 ZKTree 合约中的 _nullify 函数，并增加了所选选项的投票计数。
    function vote(
        uint _option,
        uint256 _nullifier,
        uint256 _root,
        uint[2] memory _proof_a,
        uint[2][2] memory _proof_b,
        uint[2] memory _proof_c
    ) external {
        require(_option <= numOptions, "Invalid option!");
        _nullify(
            bytes32(_nullifier),
            bytes32(_root),
            _proof_a,
            _proof_b,
            _proof_c
        );
        optionCounter[_option] = optionCounter[_option] + 1;
    }

//    定义了 getOptionCounter 函数，用于检索特定选项的投票计数。
    function getOptionCounter(uint _option) external view returns (uint) {
        return optionCounter[_option];
    }
}
