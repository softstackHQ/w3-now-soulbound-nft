// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import {ERC721, ERC721URIStorage} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract SoulboundNft is ERC721URIStorage {
    constructor() ERC721("SoulboundNft", "SB-NFT") {}
}
