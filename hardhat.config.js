require("@nomiclabs/hardhat-waffle");
require("dotenv").config();
require("@nomiclabs/hardhat-etherscan");

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  solidity: "0.8.4",
  networks: {
    rinkeby: {
      url: "https://eth-rinkeby.alchemyapi.io/v2/_pL04RZSq8RzH_qoUGZJ67CuXltq1d37",
      accounts: [process.env.PRIVATE_KEY],
    },
  },
  etherscan: {
    apiKey: "4F5FQTEEWTYYF73PK9J6X3G5STKDCXT7AQ",
  },
};
