// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "./ERC1155Metadata.sol";
import "./MinterRole.sol";


abstract contract ERC1155MetadataMintable is ERC1155, MinterRole {
  
    function mintWithTokenURI(address account, uint256 id, uint256 amount, bytes memory data, string memory tokenURI) public Minteronly returns (bool) {
        _mint(account, id, amount,data);
        _setURI(tokenURI);
        return true;
    }

        function batchmintWithTokenURI(address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data, string memory tokenURI) public Minteronly returns (bool) {
        _mintBatch(to, ids,amounts,data);
        _setURI(tokenURI);
        return true;    
    }

}