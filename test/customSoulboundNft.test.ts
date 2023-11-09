/* eslint-disable node/no-missing-import */
import { expect } from "chai"
import { CustomSoulboundNft } from "../typechain-types"
import { ethers } from "hardhat"

describe("Custom Soulbound Nft", function () {
    let soulboundNft: CustomSoulboundNft
    let receiver: string
    beforeEach(async function () {
        const signers = await ethers.getSigners()
        receiver = await signers[1].getAddress()
        const owner = await signers[0].getAddress()

        const SoulboundNft =
            await ethers.getContractFactory("CustomSoulboundNft")
        soulboundNft = (await SoulboundNft.deploy(
            "SoulboundNft",
            "SB",
            "",
            owner
        )) as unknown as CustomSoulboundNft
    })

    it("Should mint NFT by owner", async function () {
        await soulboundNft.safeMint(receiver, "ipfs://testtokenuri")
        expect(await soulboundNft.balanceOf(receiver)).to.equal(1)
        expect(await soulboundNft.ownerOf(0)).to.equal(receiver)
    })

    it("Should emit transfer event on minting", async function () {
        await expect(soulboundNft.safeMint(receiver, "ipfs://testtokenuri"))
            .to.emit(soulboundNft, "Transfer")
            .withArgs(ethers.ZeroAddress, receiver, 0)
    })

    it("Should set token URI properly", async function () {
        const tokenUri1 = "ipfs://testtokenuri1"
        await soulboundNft.safeMint(receiver, tokenUri1)
        expect(await soulboundNft.tokenURI(0)).to.equal(tokenUri1)

        const [, , receiver2] = await ethers.getSigners()
        const receiverAddress2 = await receiver2.getAddress()
        const tokenUri2 = "ipfs://testtokenuri2"
        await soulboundNft.safeMint(receiverAddress2, tokenUri2)
        expect(await soulboundNft.tokenURI(1)).to.equal(tokenUri2)
    })

    it("Should increment token id properly", async function () {
        const [, , receiver2] = await ethers.getSigners()
        const receiverAddress2 = await receiver2.getAddress()
        await soulboundNft.safeMint(receiver, "testtokenuri1")
        await soulboundNft.safeMint(receiver2, "testtokenuri2")
        expect(await soulboundNft.balanceOf(receiver)).to.equal(1)
        expect(await soulboundNft.balanceOf(receiver2)).to.equal(1)
        expect(await soulboundNft.ownerOf(0)).to.equal(receiver)
        expect(await soulboundNft.ownerOf(1)).to.equal(receiverAddress2)
    })

    it("Should revert minting NFT to non receiving address", async function () {
        await expect(
            soulboundNft.safeMint(ethers.ZeroAddress, "ipfs://testtokenuri")
        ).to.be.revertedWith("ERC721: mint to the zero address")

        const contractAddress = await soulboundNft.getAddress()
        await expect(
            soulboundNft.safeMint(contractAddress, "ipfs://testtokenuri")
        ).to.be.revertedWith(
            "ERC721: transfer to non ERC721Receiver implementer"
        )
    })
    it("Should revert minting NFT to same address twice", async function () {
        await soulboundNft.safeMint(receiver, "testtokenuri1")
        expect(await soulboundNft.balanceOf(receiver)).to.equal(1)
        await expect(
            soulboundNft.safeMint(receiver, "ipfs://testtokenuri2")
        ).to.be.revertedWith("SB-Nft: already minted")
    })

    it("Should revert minting NFT by non-owner", async function () {
        const [, , nonOwner] = await ethers.getSigners()
        await expect(
            soulboundNft
                .connect(nonOwner)
                .safeMint(receiver, "ipfs://testtokenuri")
        ).to.be.revertedWith("Ownable: caller is not the owner")
    })

    it("Should revert minting NFT with no uri provided", async function () {
        await expect(soulboundNft.safeMint(receiver, "")).to.be.revertedWith(
            "SB-Nft: no uri"
        )
    })

    it("Should burn NFT by token owner", async function () {
        const [, receiverSigner] = await ethers.getSigners()
        await soulboundNft.safeMint(receiver, "ipfs://testtokenuri")
        await soulboundNft.connect(receiverSigner).unequip(0)
    })

    it("Should revert buring NFT by non token owner", async function () {
        await soulboundNft.safeMint(receiver, "ipfs://testtokenuri")
        await expect(soulboundNft.unequip(0)).to.be.revertedWith(
            "SB-Nft: not owner"
        )
    })

    it("Should revert transferring NFT", async function () {
        const [, receiverSigner, toAddress] = await ethers.getSigners()
        const to = await toAddress.getAddress()
        await soulboundNft.safeMint(receiver, "ipfs://testtokenuri")
        await expect(
            soulboundNft
                .connect(receiverSigner)
                ["safeTransferFrom(address,address,uint256)"](receiver, to, 0)
        ).to.be.revertedWithCustomError(soulboundNft, "NotImplemented")
    })
})
