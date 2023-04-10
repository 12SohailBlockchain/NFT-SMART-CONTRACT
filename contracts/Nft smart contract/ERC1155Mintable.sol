// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "./MinterRole.sol";


abstract contract ERC1155Mintable is ERC1155, MinterRole {

    bool public anyoneCanMint;

    function _setMintableOption(bool _anyoneCanMint) internal {
        anyoneCanMint = _anyoneCanMint;
    }

    function mint(address to,
        uint256 id,
        uint256 amount,
        bytes memory data)
        public
        onlyMinter
        returns (bool)
    {
        _mint(to,id,amount, data);
        return true;
    }
    function mintBatch(
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) public onlyMinter returns(bool)
    {
        _mintBatch(to, ids, amounts, data);
        return true;
    }

    function canIMint() public view returns (bool) {
        return anyoneCanMint || isMinter(msg.sender);
    }

    /**
     * Open modifier to anyone can mint possibility
     */
    modifier onlyMinter() {
        string memory mensaje;
        require(
            canIMint(),
            "MinterRole: caller does not have the Minter role"
        );
        _;
    }

}