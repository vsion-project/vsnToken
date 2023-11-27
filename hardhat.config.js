require("@nomicfoundation/hardhat-toolbox");
require("@nomicfoundation/hardhat-chai-matchers");
require("@nomiclabs/hardhat-ethers");
require("@nomiclabs/hardhat-etherscan");
require("dotenv").config();
const fs = require("fs");
const privateKey =
  fs.readFileSync(".secret").toString().trim() || "01234567890123456789";

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  defaultNetwork: "testnet",
  networks: {
    hardhat: {
      chainId: 1337,
    },
    testnet: {
      url: "https://bsc-testnet.publicnode.com",
      chainId: 97,
      gasPrice: 20000000000,
      accounts: [privateKey],
    },
    mainnet: {
      url: "https://bsc-dataseed.binance.org/",
      chainId: 56,
      gasPrice: 20000000000,
      accounts: [privateKey],
    },
    arbitrumTestnet: {
      gasPrice: 20000000000,
      chainId: 421613,
      url: "https://goerli-rollup.arbitrum.io/rpc",
      accounts: [privateKey],
    },
    arbitrumMainet: {
      gasPrice: 100000000,
      chainId: 42161,
      url: "https://arb1.arbitrum.io/rpc",
      accounts: [privateKey],
    },
  },
  etherscan: {
    // Your API key for Etherscan
    // Obtain one at https://Etherscan.com/
    apiKey: "XPZX2DNKXWKWT4PUTZCM8SIB3915Y1YQF4", //"BXD2WA7SUPBI7JFTUKKVFCYJPH5SMMWY7T", // VHNQWFWFW164KVQ8VDAMDI4E9IYPSGTC1I
  },
  solidity: "0.8.9",
  settings: {
    optimizer: {
      enabled: true,
      runs: 2000,
      details: {
        yul: true,
      },
    },
  },
};
