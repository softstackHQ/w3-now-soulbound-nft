// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import {ERC721, IERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {ERC721URIStorage} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import {Ownable, Ownable2Step} from "@openzeppelin/contracts/access/Ownable2Step.sol";
import {IERC4973} from "./IERC4973.sol";

contract SoulboundNft is ERC721URIStorage, Ownable2Step, IERC4973 {
    uint256 private _tokenIdCounter;

    constructor() ERC721("SoulboundNft", "SB-NFT") Ownable(msg.sender) {}

    function safeMint(address to, string memory uri) public onlyOwner {
        _safeMint(to, _tokenIdCounter);
        _setTokenURI(_tokenIdCounter, uri);
        _tokenIdCounter++;
    }

    function unequip(uint256 tokenId) external {
        require(ownerOf(tokenId) == msg.sender, "SB-Nft: not owner");
        _burn(tokenId);
    }

    function give(
        address to,
        bytes calldata metadata,
        bytes calldata signature
    ) external returns (uint256) {
        return 0;
    }

    function take(
        address from,
        bytes calldata metadata,
        bytes calldata signature
    ) external returns (uint256) {
        return 0;
    }

    function decodeURI(
        bytes calldata metadata
    ) external returns (string memory) {
        return "";
    }

    function balanceOf(
        address owner
    ) public view override(ERC721, IERC4973, IERC721) returns (uint256) {
        return super.balanceOf(owner);
    }

    function ownerOf(
        uint256 tokenId
    ) public view override(ERC721, IERC4973, IERC721) returns (address) {
        return super.ownerOf(tokenId);
    }

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(
        bytes4 interfaceId
    ) public view virtual override(ERC721URIStorage) returns (bool) {
        return
            interfaceId == type(IERC4973).interfaceId ||
            super.supportsInterface(interfaceId);
    }
}
