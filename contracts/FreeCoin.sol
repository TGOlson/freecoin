pragma solidity ^0.4.0;

import "ERC721Interface.sol";
import "Owned.sol";

// https://github.com/ethereum/eips/issues/721
contract FreeCoin is ERC721Interface, Owned {
    string public name;
    string public symbol;

    uint24 public _totalSupply;
    uint24 public maxSupply;

    address[] public ownerByTokenId;

    uint public lastDistributionBlockNum;

    uint public distributionInterval;
    address[] public registeredAddresses;

    mapping (uint => address) public approvals;

    event Transfer(
        address indexed _from,
        address indexed _to,
        uint _tokenId
    );

    event Approval(
        address indexed _owner,
        address indexed _approved,
        uint _tokenId
    );

    function FreeCoin() public {
        name   = "FreeCoin";
        symbol = "FREE";

        _totalSupply = 0;
        maxSupply    = 1000000; // 1M;

        distributionInterval = 2; // num blocks

        // start faucet 3 blocks from now (current + 1 + distributionInterval)
        lastDistributionBlockNum = block.number + 1;
    }

    function totalSupply() public constant returns (uint) {
        return _totalSupply;
    }

    // inefficient, avoid calling on-chain
    function balanceOf(address _owner) public constant returns (uint _balance) {
        for (uint id = 0; id < _totalSupply; id++) {
            if (ownerByTokenId[id] == _owner) {
                _balance += 1;
            }
        }
    }

    function ownerOf(uint _tokenId) public constant returns (address _owner) {
        require(_tokenId < _totalSupply);

        return ownerByTokenId[_tokenId];
    }

    // todo: think there are some other requirements
    function approve(address _to, uint256 _tokenId) public {
        require(msg.sender == ownerOf(_tokenId));

        address previousApproval = approvals[_tokenId];
        approvals[_tokenId] = _to;

        // note: the only case where we don't send an event is when
        // previous state was '0', and next state is '0'
        if (_to != address(0) || previousApproval != 0) {
            Approval(msg.sender, _to, _tokenId);
        }
    }

    function takeOwnership(uint256 _tokenId) public {
        require(ownerOf(_tokenId) != msg.sender);
        require(approvals[_tokenId] == msg.sender);

        address previousApproval = approvals[_tokenId];
        approvals[_tokenId] = address(0);

        Transfer(previousApproval, msg.sender, _tokenId);
    }

    function transfer(address _to, uint _tokenId) public {
        require(msg.sender == ownerOf(_tokenId));
        require(_to != address(0));

        approvals[_tokenId] = address(0);
        ownerByTokenId[_tokenId] = _to;

        Transfer(msg.sender, _to, _tokenId);
    }

    // todo: very inefficient, see how other contracts handle this
    function tokenOfOwnerByIndex(address _owner, uint256 _index) public constant returns (uint _tokenId) {
        uint current = 0;

        // todo: cleanup
        for (uint id = 0; id < _totalSupply; id++) {
            if (ownerByTokenId[id] == _owner) {
                current += 1;
                if (current == _index) {
                    _tokenId = current;
                    break;
                }
            }
        }
    }

    function tokenMetadata(uint256 _tokenId) public constant returns (string _infoUrl) {
        // todo
        return "";
    }

    // todo: needs to only be accessible by owner
    function registerAddresses(address[] addresses) public onlyOwner {
        for (uint i = 0; i < addresses.length; i++) {
            // todo: enforce uniqueness?
            registeredAddresses.push(addresses[i]);
        }
    }

    // note: this function is public, anyone can call it
    // the internal logic ensures that tokens will only be distributed under correct conditions
    function distributeToken() public {
        uint tokensToDistribute = (block.number - lastDistributionBlockNum) / distributionInterval;

        require(tokensToDistribute > 0);

        // todo: if totalSupply == maxSupply see if any tokens have been returned to contract
        require(_totalSupply < maxSupply);

        lastDistributionBlockNum = block.number;

        // note: this allows contract to distribute multiple token in cases when
        // multiple distribution periods have elapsed since contract was last called
        while (tokensToDistribute > 0) {
            uint blockNum = block.number - 1 - ((tokensToDistribute - 1) * distributionInterval);
            uint index = randFromBlock(blockNum, registeredAddresses.length);
            address addr = registeredAddresses[index];

            ownerByTokenId.push(addr);
            Transfer(address(0), addr, _totalSupply);

            _totalSupply += 1;

            tokensToDistribute--;
        }
    }

    // note: using previous block hashes as a source of randomness exposes this token
    // to a few potential security flaws (namely, miners could theoretically game the distribution)
    // however, this is a free coin! we expect low or no value for these tokens
    function randFromBlock(uint blockNum, uint max) private view returns (uint) {
        bytes32 prevHash = block.blockhash(blockNum);
        return uint(prevHash) % max;
    }

    // dev only, for stepping through blocks
    function blockNum() public returns (uint) {
        return block.number;
    }

    // todo: kill contract
    // todo: withdraw any funds accidentally sent to contract
}
