// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import {ERC721, IERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Ownable, Ownable2Step} from "@openzeppelin/contracts/access/Ownable2Step.sol";

/**
 * @title SoulboundNft
 * @dev Contract for soulbounded NFTs, which can be minted by the contract
 * owner and be burned by the token holder. Each address can only hold one
 * NFT at a time and has to be an EOA or implement the `onERC721Received`
 * function. Soulbound NFTs are not transferable. Every minted token has
 * the same metadata, which is the URI of the token contract.
 */
contract SoulboundNft is ERC721, Ownable2Step {
    // the token id counter is used to assign a new token id to each minted token
    uint256 private _tokenIdCounter;
    // the token URI is the metadata of the token and is the same for all tokens
    string private _tokenURI;

    /**
     * @dev Initializes the contract by setting a `name`, a `symbol` and a `tokenURI`
     * to the token collection and transferring the ownership to the `owner_`.
     * @param name_ The name of the token collection.
     * @param symbol_ The symbol of the token collection.
     * @param tokenURI_ The URI of the token collection.
     * @param owner_ The address of the contract owner.
     */
    constructor(
        string memory name_,
        string memory symbol_,
        string memory tokenURI_,
        address owner_
    ) ERC721(name_, symbol_) Ownable() {
        _transferOwnership(owner_);
        _tokenURI = tokenURI_;
    }

    /**
     * @dev Mints a new token and assigns it to `to`. The token id is
     * incremented by one after each minting. Only the contract owner
     * can mint new tokens. The `to` address must not already own a token.
     * @param to The address to mint the token to.
     */
    function safeMint(address to) public onlyOwner {
        require(balanceOf(to) == 0, "SB-Nft: already minted");
        _safeMint(to, _tokenIdCounter);
        _tokenIdCounter++;
    }

    /**
     * @dev Burns the token with the given `tokenId`. The token can only be
     * burned by the token holder. The `tokenId` must exist.
     */
    function unequip(uint256 tokenId) external {
        require(ownerOf(tokenId) == msg.sender, "SB-Nft: not owner");
        _burn(tokenId);
    }

    /**
     * @dev Returns the token URI of the token collection holding the same
     * metadata for every token.
     * @return The token URI holding the metadata.
     */
    function tokenURI(uint256) public view override returns (string memory) {
        return _tokenURI;
    }

    /**
     * @dev Hook that is called before any token transfer. The function
     * reverts if the transfer is not from or to the zero address (minting
     * or burning) to prevent the token from being transferable.
     * @param from The address to transfer the token from.
     * @param to The address to transfer the token to.
     */
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
