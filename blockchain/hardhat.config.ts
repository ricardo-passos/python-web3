import '@nomiclabs/hardhat-waffle'

// types
import { HardhatUserConfig } from 'hardhat/config'

const config: HardhatUserConfig = {
  solidity: '0.7.0',
  networks: {
    ganache: {
      url: 'http://127.0.0.1:7545',
      chainId: 1337,
      gasPrice: 20000000000,
      blockGasLimit: 6721975,
      mining: {
        auto: true,
      },
      coinbase: 'ONE',
    },
  },
}

export default config
