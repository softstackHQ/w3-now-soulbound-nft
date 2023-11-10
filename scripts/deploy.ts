/* eslint-disable node/no-missing-import */
import { ethers } from "hardhat"
import deploymentArgs from "./deploymentArgs"

async function main() {
    const collection = await ethers.deployContract(
        "SoulboundNft",
        deploymentArgs
    )

    await collection.waitForDeployment()

    console.log(
        `Collection ${deploymentArgs[0]}(${deploymentArgs[1]}) with tokenURI 
        ${deploymentArgs[2]} and owner ${deploymentArgs[3]} deployed to ${collection.target}`
    )
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
    console.error(error)
    process.exitCode = 1
})
