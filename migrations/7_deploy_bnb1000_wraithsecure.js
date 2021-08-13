/* global artifacts */
const BNBWraith = artifacts.require('BNBWraith')
const Verifier = artifacts.require('Verifier')
const hasherContract = artifacts.require('Hasher')


module.exports = function(deployer, network, accounts) {
  return deployer.then(async () => {
    const verifier = await Verifier.deployed()
    const hasherInstance = await hasherContract.deployed()
    await BNBWraith.link(hasherContract, hasherInstance.address)
    const wraith = await deployer.deploy(BNBWraith, verifier.address, '1000000000000000000000', 20, accounts[0])
    console.log('BNB1000 WraithSecure\'s address ', wraith.address)
  })
}
