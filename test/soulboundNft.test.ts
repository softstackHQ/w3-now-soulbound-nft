/* eslint-disable node/no-missing-import */
import { expect } from "chai"
import { SoulboundNft } from "../typechain-types"
import { ethers } from "hardhat"

describe("Soulbound Nft", function () {
    let soulboundNft: SoulboundNft
    let receiver: string
    const tokenURI = "ipfs://testtokenuri"
    beforeEach(async function () {
        const signers = await ethers.getSigners()
        receiver = await signers[1].getAddress()
        const owner = await signers[0].getAddress()

        const SoulboundNft = await ethers.getContractFactory("SoulboundNft")
        soulboundNft = (await SoulboundNft.deploy(
            "SoulboundNft",
            "SB",
            tokenURI,
            owner
        )) as unknown as SoulboundNft
    })

    it("Should mint NFT by owner", async function () {
        await soulboundNft.safeMint(receiver)
        expect(await soulboundNft.balanceOf(receiver)).to.equal(1)
        expect(await soulboundNft.ownerOf(0)).to.equal(receiver)
    })

    it("Should emit transfer event on minting", async function () {
        await expect(soulboundNft.safeMint(receiver))
            .to.emit(soulboundNft, "Transfer")
            .withArgs(ethers.ZeroAddress, receiver, 0)
    })

    it("Should set token URI properly", async function () {
        await soulboundNft.safeMint(receiver)
        expect(await soulboundNft.tokenURI(0)).to.equal(tokenURI)

        const [, , receiver2] = await ethers.getSigners()
        const receiverAddress2 = await receiver2.getAddress()
        await soulboundNft.safeMint(receiverAddress2)
        expect(await soulboundNft.tokenURI(1)).to.equal(tokenURI)
    })

    it("Should increment token id properly", async function () {
        const [, , receiver2] = await ethers.getSigners()
        const receiverAddress2 = await receiver2.getAddress()
        await soulboundNft.safeMint(receiver)
        await soulboundNft.safeMint(receiver2)
        expect(await soulboundNft.balanceOf(receiver)).to.equal(1)
        expect(await soulboundNft.balanceOf(receiver2)).to.equal(1)
        expect(await soulboundNft.ownerOf(0)).to.equal(receiver)
        expect(await soulboundNft.ownerOf(1)).to.equal(receiverAddress2)
    })

    it("Should revert minting NFT to non receiving address", async function () {
        await expect(
            soulboundNft.safeMint(ethers.ZeroAddress)
        ).to.be.revertedWith("ERC721: address zero is not a valid owner")

        const contractAddress = await soulboundNft.getAddress()
        await expect(soulboundNft.safeMint(contractAddress)).to.be.revertedWith(
            "ERC721: transfer to non ERC721Receiver implementer"
        )
    })

    it("Should revert minting NFT to same address twice", async function () {
        await soulboundNft.safeMint(receiver)
        expect(await soulboundNft.balanceOf(receiver)).to.equal(1)
        await expect(soulboundNft.safeMint(receiver)).to.be.revertedWith(
            "SB-Nft: already minted"
        )
    })

    it("Should revert minting NFT by non-owner", async function () {
        const [, , nonOwner] = await ethers.getSigners()
        await expect(
            soulboundNft.connect(nonOwner).safeMint(receiver)
        ).to.be.revertedWith("Ownable: caller is not the owner")
    })

    it("Should burn NFT by token owner", async function () {
        const [, receiverSigner] = await ethers.getSigners()
        await soulboundNft.safeMint(receiver)
        await soulboundNft.connect(receiverSigner).unequip(0)
    })

    it("Should revert buring NFT by non token owner", async function () {
        await soulboundNft.safeMint(receiver)
        await expect(soulboundNft.unequip(0)).to.be.revertedWith(
            "SB-Nft: not owner"
        )
    })

    it("Should revert transferring NFT", async function () {
        const [, receiverSigner, toAddress] = await ethers.getSigners()
        const to = await toAddress.getAddress()
        await soulboundNft.safeMint(receiver)
        await expect(
            soulboundNft
                .connect(receiverSigner)
                ["safeTransferFrom(address,address,uint256)"](receiver, to, 0)
        ).to.be.revertedWith("SB-Nft: not transferable")
    })
})
