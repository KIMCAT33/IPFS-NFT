// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import '@openzeppelin/contracts/access/Ownable.sol';

contract UniqueAsset is ERC721, Ownable {
    using Counters for Counters.Counter;
    using Strings for uint256;
    
    Counters.Counter private _tokenIds; 
    mapping(string => uint8) hashes; // IPFS hashes associated with tokens 
    
    mapping(uint256 => string) private _tokenURIs;

    string private _baseURIextended;

    constructor() public ERC721("UniqueAsset", "UNA"){}

    function setBaseURI(string memory baseURI_) external onlyOwner() {
        _baseURIextended = baseURI_;
    }

    function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
        require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
        _tokenURIs[tokenId] = _tokenURI;
    }

    function awardItem(address recipient, string memory hash, string memory metadata) public returns (uint256) {
        // recipient : person's wallet address who will receieve the NFT
        // metadata : a link to the JSON metadata for the asset (asset name, a link to an image etc..)

        require(hashes[hash] != 1); // if it's 1, it's already used 
        hashes[hash] = 1;
        _tokenIds.increment();

        uint256 newItemId = _tokenIds.current();
        _mint(recipient, newItemId);
        
        _setTokenURI(newItemId, metadata);

        return newItemId;

    }


}