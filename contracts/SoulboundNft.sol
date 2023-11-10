// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import {ERC721, IERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Ownable, Ownable2Step} from "@openzeppelin/contracts/access/Ownable2Step.sol";

contract SoulboundNft is ERC721, Ownable2Step {
    uint256 private _tokenIdCounter;
    string private _tokenURI;

    constructor(
        string memory name_,
        string memory symbol_,
        string memory tokenURI_,
        address owner_
    ) ERC721(name_, symbol_) Ownable() {
        _transferOwnership(owner_);
        _tokenURI = tokenURI_;
    }

    function safeMint(address to) public onlyOwner {
        require(balanceOf(to) == 0, "SB-Nft: already minted");
        _safeMint(to, _tokenIdCounter);
        _tokenIdCounter++;
    }

    function unequip(uint256 tokenId) external {
        require(ownerOf(tokenId) == msg.sender, "SB-Nft: not owner");
        _burn(tokenId);
    }

    function tokenURI(uint256) public view override returns (string memory) {
        return _tokenURI;
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
