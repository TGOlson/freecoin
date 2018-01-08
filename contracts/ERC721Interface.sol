pragma solidity ^0.4.0;

// https://github.com/ethereum/eips/issues/721
interface ERC721Interface {
    function totalSupply() public constant returns (uint256 _totalSupply);
    function balanceOf(address _owner) public constant returns (uint256 _balance);
    function ownerOf(uint _tokenId) public constant returns (address _owner);
    function approve(address _to, uint256 _tokenId) public;
    function takeOwnership(uint256 _tokenId) public;
    function transfer(address _to, uint _tokenId) public;
    function tokenOfOwnerByIndex(address _owner, uint256 _index) public constant returns (uint _tokenId);
    function tokenMetadata(uint256 _tokenId) public constant returns (string _infoUrl);

    event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
    event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
}
