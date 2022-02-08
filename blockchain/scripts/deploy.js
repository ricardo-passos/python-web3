const { ethers } = require('hardhat')

async function main() {
  const [deployer] = await ethers.getSigners()

  console.log('Deploying contracts with the account:', deployer)
  console.log('Account balance:', (await deployer.getBalance()).toString())

  const Token = await ethers.getContractFactory('Token')
  const token = Token.deploy()

  console.log('Token address:', token.address)
}

main()
  .then(() => process.exit())
  .catch((error) => {
    console.error(error)
    process.exit(1)
  })
