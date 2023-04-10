//SPDX-License-Identifier:MIT
pragma solidity ^0.8.13;

interface IEnumerable {

    function totalSupply()
    external
    view
    returns
    (uint);
    
    function tokenOfOwnerByIndex(address, uint)
    external
    view
    returns
    (uint);
    
    function tokenByIndex(uint)
    external 
    view
    returns
    (uint);
}

contract EnumerableNFT is IEnumerable{
    mapping (address => mapping(uint=> uint))_ownerOfTokenByIndex;
    mapping (uint=> uint) _ownerTokenIdToIndex;
    mapping(uint=> uint) allTokensIndex;
    uint[] allTokens;
    address public  userAccnt;
    mapping (address=>uint )_balances;
    address payable owner;
    mapping (uint=> address )tokenApprovals;

    mapping (uint=>address)_owners;
    mapping (address => mapping(address=> bool))_operatorApprovals;


    event Transfer(address from, address to, uint  tokenId);
    event Burned(uint tokenId);

    modifier onlyBy(address _CheckOwnerAddr) {
        require(_CheckOwnerAddr == owner,"You don not have authorization");
        _;
    }

    constructor (uint _amount) {
        owner = payable(msg.sender);
        require(msg.sender!= address(0),"Invalid Address");
        require(_amount>0,"Invalid total supply");

        userAccnt = msg.sender;
        
        for(uint i =0; i < _amount; i++) {
            mint(userAccnt,i*100);

        }
    }
    event ApprovedForAll(address owner, address operator, bool approved);

    function setApprovalForAll(address _owner, address operator, bool approved) public virtual {
        _operatorApprovals[_owner][operator] = approved;
        emit ApprovedForAll(_owner,operator, approved);
    }

    
    function isApproved(address _owner, address operator) public virtual returns (bool) 
    {
        return _operatorApprovals[_owner][operator];

    }


    function _exists(uint tokenId) private view returns (bool) {
        return (_owners[tokenId]!=address(0));
    }
 
    function beforeTokenTransfer(address from, address to,uint tokenId) private  {
        if (from == address(0))
        {//Case1:Mint
            addTokensToAllTokensEnumeration(tokenId);
            addTokentoOwnerEnumeration(to,tokenId);
        }
        else if (to == address(0)){
            //Case2: Burn
            _removeTokenFromAllTokensEnumeration(tokenId);
        }
        else if(to!=from) { 
            //Case3: Transfer
            addTokentoOwnerEnumeration(to,tokenId);
        }
    }

//Case1: Mint
    function mint(address to,uint tokenId) public {
        beforeTokenTransfer(address(0),to,tokenId);
        _balances[to]+=1;
        _owners[tokenId] = to;

    }

 //Case2:Burn
     function burn(uint tokenId) public {
        // require(_exists(tokenId),"TokenId doesn't exist to burn");
        address owner_ = _owners[tokenId];
        beforeTokenTransfer(owner_, address(0),tokenId);
        _balances[owner_]-=1;
        delete _owners[tokenId];
    }



//Case3: Transfer
    function transfer(address from, address to, uint tokenId) public {
        
        require(from != address(0),"Invalid from address");
        require(to!=address(0), "Invalid to address");
        require(isApproved(from,to) || getApproved(tokenId)== to,"No approval for this transaction");
        beforeTokenTransfer(from,to,tokenId);
        _balances[from]-=1;
        _balances[to] +=1;
        _owners[tokenId]= to;
        emit Transfer(from,to, tokenId);
    }




    function getApproved(uint tokenId) public view returns (address) {
        require(_exists(tokenId),"Invalid token Id");
        return tokenApprovals[tokenId];

    }
    event Approval(address to, uint tokenId);

    function setApproval(address to, uint tokenId) public onlyBy(owner) {
        tokenApprovals[tokenId] = to;
        emit Approval( to,  tokenId);
    }



    function tokenOfOwnerByIndex(address _userAccnt, uint _idx)
        external
        view
        returns
        (uint){ 
        return _ownerOfTokenByIndex[_userAccnt][_idx];

    }

    function getInterfaceID() external pure returns (bytes4) {
        return type(IEnumerable).interfaceId;

    }

    function supportsInterfaceID(bytes4 _interfaceID) external pure returns (bool)
    {
        return _interfaceID == type(IEnumerable).interfaceId;
        }


    function addTokentoOwnerEnumeration(address _owner,uint _tokenId) internal {
        uint length= balanceOf(_owner);
        _ownerOfTokenByIndex[_owner][length]=_tokenId;
        _ownerTokenIdToIndex[_tokenId]=length;
        }

    function addTokensToAllTokensEnumeration(uint tokenId) public {
        allTokensIndex[tokenId] = allTokens.length;
        allTokens.push(tokenId);
        
    }

    function _removeTokenFromOwnerEnumeration(address _owner, uint _id)
    internal
    {
       uint _idx = _ownerTokenIdToIndex[_id];
       uint lastTokenIdx = balanceOf(_owner)-1;
        if(_idx!=lastTokenIdx) {
            uint lastTokenId = _ownerOfTokenByIndex[_owner][lastTokenIdx];
            _ownerOfTokenByIndex[_owner][_idx] = lastTokenId;
            _ownerTokenIdToIndex[lastTokenId] = _idx;
       }    
        delete _ownerTokenIdToIndex[_id];
        delete _ownerOfTokenByIndex[_owner][lastTokenIdx];
    }


    function _removeTokenFromAllTokensEnumeration(uint tokenId) internal {
        uint lastIndex = allTokens.length -1;
        uint lastTokenId = allTokens[lastIndex];
        allTokensIndex[tokenId] = lastTokenId;
        allTokensIndex[lastIndex] = tokenId;
        delete allTokensIndex[lastIndex];
        allTokens.pop();
        
    }

    function balanceOf(address _owner) public view returns (uint) {
        return _balances[_owner];
    }

    function totalSupply() public view returns (uint) {
        return allTokens.length;
    }


    function tokenByIndex(uint index)
        external 
        view
    returns
    (uint){

        return (allTokens[index]);
    }

}