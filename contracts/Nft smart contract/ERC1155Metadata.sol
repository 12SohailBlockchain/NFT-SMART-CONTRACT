// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol";
import "@openzeppelin/contracts/utils/introspection/ERC165Storage.sol";


abstract contract ERC1155Metadata is ERC165Storage {

    string private _name;

    string private _symbol;

    // Optional mapping for token URIs
  mapping(uint256 => string) private _tokenURIs;
  mapping(uint256 => address) private _checkaddress;
    string private _uri;

    /*
     *     bytes4(keccak256('name()')) == 0x06fdde03
     *     bytes4(keccak256('symbol()')) == 0x95d89b41
     *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
     *
     *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
     */
    bytes4 private constant _INTERFACE_ID_ERC1155_METADATA = 0xd9b67a26;

    /**
     * @dev Constructor function
     */
    constructor (string memory name_, string memory symbol_) {

         _name = name_;
        _symbol = symbol_;
        // register the supported interfaces to conform to ERC721 via ERC165
                  _registerInterface(_INTERFACE_ID_ERC1155_METADATA);
    }

    function name() external view returns (string memory) {
        return _name;
    }

    function symbol() external view returns (string memory) {
        return _symbol;
    }


    function tokenURI(uint256 tokenId) external view returns (string memory) {
        require(_checkaddress[tokenId] != address(0), "ERC1155Metadata: URI query for nonexistent token");
        return _tokenURIs[tokenId];
    }


     function _setTokenURI(uint256 tokenId, string memory uri) internal {

        require(_checkaddress[tokenId] != address(0), "ERC1155Metadata: URI set of nonexistent token");
        _tokenURIs[tokenId] = uri;
    }


}