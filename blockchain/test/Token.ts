import { expect } from 'chai'
import { ethers } from 'hardhat' // although ethers is globally available at runtime, I don't code that does 'magic'

// types
import type { Contract } from 'ethers'
import type { SignerWithAddress } from '@nomiclabs/hardhat-ethers/signers'

describe('Simple Storage contract', () => {
  let owner: SignerWithAddress, wallet1: SignerWithAddress, token: Contract

  beforeEach(async () => {
    ;[owner, wallet1] = await ethers.getSigners()

    const Token = await ethers.getContractFactory('Token')
    token = await Token.deploy()
  })

  it('Should transfer tokens between accounts', async () => {
    await token.transfer(wallet1.address, 50)

    const wallet1Balance = await token.balanceOf(wallet1.address)
    expect(wallet1Balance).to.equal(50)
  })
})
