// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";


contract Alchemy is ERC721, ERC721Enumerable, ERC721URIStorage, Ownable {
    Counters.Counter private _tokenIdCounter;
    uint256 MAX_SUPPLY = 100000;

    constructor() ERC721("Alchemy", "ALCH") {}
}