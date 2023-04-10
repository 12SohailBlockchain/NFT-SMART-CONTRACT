pragma solidity ^0.6.0;

contract NFTMarketplace {
    mapping(address => uint256) public balanceOf11;
    mapping(uint256 => address) public ownerOf;
    mapping(uint256 => string) public tokenURI;
    mapping(address => mapping(uint256 => bool)) public tokensOfOwner;

    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    constructor() public {
        // Initialize the contract
    }

    function mint(address to, uint256 tokenId, string memory tokenURI) public {
        require(msg.sender == ownerOf[tokenId], "Only the owner can mint a new token.");
        require(tokenURI.length > 0, "The token URI must not be empty.");
        require(tokenId > 0, "The token ID must be greater than 0.");

        // Mint the new token and assign it to the specified address
        balanceOf[to]++;
        tokensOfOwner[to][tokenId] = true;
        ownerOf[tokenId] = to;
        tokenURI[tokenId] = tokenURI;

        emit Transfer(address(0), to, tokenId);
    }

    function transfer(address to, uint256 tokenId) public {
        require(msg.sender == ownerOf[tokenId], "Only the owner can transfer a token.");

        // Transfer the token to the specified address
        balanceOf[msg.sender]--;
        tokensOfOwner[msg.sender][tokenId] = false;
        ownerOf[tokenId] = to;
        balanceOf[to]++;
        tokensOfOwner[to][tokenId] = true;

        emit Transfer(msg.sender, to, tokenId);
    }

    function balanceOf(address owner) public view returns (uint256) {
        return balanceOf[owner];
    }

    function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256) {
        require(index >= 0 && index < balanceOf[owner], "Index out of bounds.");

        // Retrieve the token ID of the owner's token at the specified index
        uint256 tokenCount = 0;
        for (uint256 tokenId = 0; tokenId < ownerOf.length; tokenId++) {
            if (ownerOf[tokenId] == owner) {
                if (tokenCount == index) {
                    return tokenId;
                }
                tokenCount++;
            }
        }
    }
}