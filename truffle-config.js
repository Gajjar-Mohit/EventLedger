const HDWalletProvider = require("@truffle/hdwallet-provider");
require("dotenv").config(); // Load .env file
module.exports = {
  networks: {
    matic: {
      provider: () =>
        new HDWalletProvider(
          process.env.MNEMONIC,
          `https://polygon-mumbai.g.alchemy.com/v2/_545cXZb3whqPZ9eLyvHxT1h771CJGx1`
        ),
      network_id: 80001,
      confirmations: 2,
      timeoutBlocks: 200,
      skipDryRun: true,
      gas: 6000000,
      gasPrice: 10000000000,
    },
    development: {
      host: "0.0.0.0",
      port: 7545,
      network_id: "5777",
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
0xa096247d987a688f2825c70009aa5261df06197e;
