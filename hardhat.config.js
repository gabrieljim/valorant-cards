const { parseEther } = require("ethers/lib/utils");

require("@nomiclabs/hardhat-waffle");
require("dotenv").config();
require("@nomiclabs/hardhat-etherscan");

/**
 * @type import('hardhat/config').HardhatUserConfig
 */

task("fund-link", "Funds a contract with LINK")
  .addParam("contract", "The address of the contract that requires LINK")
  .addOptionalParam("linkAddress", "Set the LINK token address")
  .setAction(async (taskArgs) => {
    const linkAddress = "0xa36085F69e2889c224210F603D836748e7dC0088";
    const contractAddr = taskArgs.contract;
    const networkId = network.name;
    console.log("Funding contract ", contractAddr, " on network ", networkId);
    const LINK_TOKEN_ABI = [
      {
        inputs: [
          { internalType: "address", name: "_to", type: "address" },
          { internalType: "uint256", name: "_value", type: "uint256" },
        ],
        name: "transfer",
        outputs: [{ internalType: "bool", name: "", type: "bool" }],
        stateMutability: "nonpayable",
        type: "function",
      },
    ];

    //Fund with 0.1 LINK token
    const amount = parseEther("1");

    //Get signer information
    const accounts = await hre.ethers.getSigners();
    const signer = accounts[0];

    //Create connection to LINK token contract and initiate the transfer
    const linkTokenContract = new ethers.Contract(
      linkAddress,
      LINK_TOKEN_ABI,
      signer
    );

    var result = await linkTokenContract
      .transfer(contractAddr, amount)
      .then(function (transaction) {
        console.log(
          "Contract ",
          contractAddr,
          " funded with 1 LINK. Transaction Hash: ",
          transaction.hash
        );
      });
  });

module.exports = {
  solidity: "0.8.4",
  networks: {
    kovan: {
      url: "https://eth-kovan.alchemyapi.io/v2/_pL04RZSq8RzH_qoUGZJ67CuXltq1d37",
      accounts: [process.env.PRIVATE_KEY],
    },
  },
  etherscan: {
    apiKey: "4F5FQTEEWTYYF73PK9J6X3G5STKDCXT7AQ",
  },
};
