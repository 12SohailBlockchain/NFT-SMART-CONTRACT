// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

contract NFTCollection is ERC721, ERC721Enumerable {
  string[] public tokenURIs;
  mapping(string => bool) _tokenURIExists;
  mapping(uint => string) _tokenIdToTokenURI;
  mapping(uint => address[]) _itemTrack;

  constructor() 
    ERC721("mTC Collection", "mTC") 
  {
//   }

//   function _beforeTokenTransfer(address from, address to, uint256 tokenId) public () {
//     super._beforeTokenTransfer(from, to, tokenId);
//   }

  function supportsInterface(bytes4 interfaceId) public view override(ERC721, ERC721Enumerable) returns (bool) {
    return super.supportsInterface(interfaceId);
  }

  function tokenURI(uint256 tokenId) public override view returns (string memory) {
    require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
    return _tokenIdToTokenURI[tokenId];
  }

  function safeMint(string memory _tokenURI) public {
    require(!_tokenURIExists[_tokenURI], 'The token URI should be unique');
    tokenURIs.push(_tokenURI);    
    uint _id = tokenURIs.length;
    _tokenIdToTokenURI[_id] = _tokenURI;
    setTrack(msg.sender, _id);
    _safeMint(msg.sender, _id);
    _tokenURIExists[_tokenURI] = true;
  }

    function setTrack(address _address, uint _id) public returns(bool){
        _itemTrack[_id].push(_address);
        return true;
    }

    function getTrack(uint _id) public view returns(address[] memory){
        address[] memory users;
        users = _itemTrack[_id];
       return users;

    }
}