const HDWalletProvider = require("@truffle/hdwallet-provider");
require("dotenv").config(); // Load .env file
module.exports = {
  networks: {
    matic: {
      provider: () =>
        new HDWalletProvider(
          process.env.MNEMONIC,
          `https://rpc-mumbai.maticvigil.com/v1/e7683e02c1cfd4b9c2f5c6b20bd61a7328f952a6`
        ),
      network_id: 80001,
      confirmations: 2,
      timeoutBlocks: 200,
      skipDryRun: true,
      gas: 6000000,
      gasPrice: 10000000000,
    },
    advanced: {
      websockets: true,
    },
  },
  contracts_build_directory: "./client/src/abis/",
  compilers: {
    solc: {
      version: "0.8.19",
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },
};
