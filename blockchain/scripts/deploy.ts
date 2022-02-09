import { ethers } from 'hardhat'

async function main() {
  const [deployer] = await ethers.getSigners()

  console.log('Deploying contracts with the account:', deployer)
  console.log('Account balance:', (await deployer.getBalance()).toString())

  const SimpleStorage = await ethers.getContractFactory('SimpleStorage')
  const simpleStorage = await SimpleStorage.deploy()

  console.log('SimpleStorage address:', simpleStorage.address)
}

main()
  .then(() => process.exit())
  .catch((error) => {
    console.error(error)
    process.exit(1)
  })
