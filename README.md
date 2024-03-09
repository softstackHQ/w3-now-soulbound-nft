# W3NOW Soulbound NFT

Für die Studie [W3NOW](https://www.w3now.de/) wurde ein "Soulbound NFT" entwickelt, der an alle Teilnehmer der Studie ausgeschüttet werden soll. Der Smart Contract erlaubt es dem Besitzer NFTs zu schürfen und an beliebige Adressen zu senden (minting). Jede Adresse darf maximal einen NFT besitzen und hat die Möglichkeit diesen eigenständig wieder zu zerstören (burnen). Damit ist das Recht auf Löschung nach Artikel 17 DSGVO abgedeckt. Die geschürften NFTs haben alle die selben Metadaten und dienen als Nachweis, an der Studie teilgenommen zu haben. Es gibt keine Möglichkeit die NFTs nach der Erstellung (initiales Senden zum Empfänger) an Dritte weiter zu transferieren. Die Token sind für ihren Lebenzyklus fest an eine Adresse gebunden.

## Scripts

To interact with this repository your can take advantage of predefined scripts for setting up, testing, linting, formating or compiling. Feel free to add your own scripts (for example for contract deployment or verification).

### Installing dependencies

To install all required project dependencies run:

```shell
npm install
```

### Compile smart contracts

To compile solidity smart contracts of this repository run:

```shell
npm run compile
```

### Run test cases for smart contract

To execute all test cases located in the _test_ folder run:

```shell
npm run test
```

### Testing code coverage

To get the current code coverage of all test for all solidity files run:

```shell
npm run coverage
```

### Deploy smart contracts

To deploy the Soulbound NFT contract follow these steps:

1. Create a .env file with the following variables ([.env.example](.env.example)) and set the values for the target network:

```
ETHERSCAN_API_KEY=ABC123ABC123ABC123ABC123ABC123ABC1
POLYGON_URL=<RPC URL FOR POLYGON NETWORK>
MUMBAI_URL=<RPC URL FOR MUMBAI NETWORK>
PRIVATE_KEY=0xabc123abc123abc123abc123abc123abc123abc123abc123abc123abc123abc1
```

2. Adjust the deployment arguments in [deploymentArgs](scripts/deploymentArgs.ts) to set the token parameters as desired:

```
const DeploymentArgs = [
    "W3NOW-NFT 2023", // collection name
    "W3NOW23", // collection symbol
    "https://ipfs.io/ipfs/QmPLosNSsFw81UZQisFzGm8mQ7HzmKSReQe6Ds2XF8c1cV", // token URI (metadata)
    "0x2Cf143175b21564bc7520FF2d893884104dB8d07", // owner address
]
```

3. Run the script to deploy the NFT contract on the desired network by selecting the proper network name.

```shell
npm run deploy <mumbai | polygon>
```

## Verifying deployed smart contracts

If you successfully deployed the NFT contract copy the contract address and run the following command to verify the contract.
Run the following command and replace `DEPLOYED_CONTRACT_ADDRESS` with the copied address of the deployed contract:

```shell
npx hardhat verify <mumbai | polygon> DEPLOYED_CONTRACT_ADDRESS
```
