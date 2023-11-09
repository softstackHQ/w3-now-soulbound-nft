// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import {ERC721, IERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {ERC721URIStorage} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import {Ownable, Ownable2Step} from "@openzeppelin/contracts/access/Ownable2Step.sol";

contract SoulboundNft is ERC721URIStorage, Ownable2Step {
    uint256 private _tokenIdCounter;

    constructor(
        string memory name_,
        string memory symbol_,
        address owner_
    ) ERC721(name_, symbol_) Ownable() {
        _transferOwnership(owner_);
    }

    function safeMint(address to, string memory uri) public onlyOwner {
        require(balanceOf(to) == 0, "SB-Nft: already minted");
        require(
            bytes(_baseURI()).length != 0 || bytes(uri).length != 0,
            "SB-Nft: no uri"
        );
        _safeMint(to, _tokenIdCounter);
        _setTokenURI(_tokenIdCounter, uri);
        _tokenIdCounter++;
    }

    function unequip(uint256 tokenId) external {
        require(ownerOf(tokenId) == msg.sender, "SB-Nft: not owner");
        _burn(tokenId);
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256,
        uint256
    ) internal pure override {
        require(
            from == address(0) || to == address(0),
            "SB-Nft: not transferable"
        );
    }
}
