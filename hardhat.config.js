require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();
require("@nomiclabs/hardhat-etherscan");

const PRIVATE_KEY = process.env.PRIVATE_KEY;
const GOERLI_URL = process.env.GOERLI_QUICK_URL;
const API_KEY = process.env.API_KEY;

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.17",
  networks: {
    goerli: {
      url: GOERLI_URL,
      accounts: [PRIVATE_KEY],
    },
  },
  etherscan: {
    apiKey: API_KEY,
  },
};
