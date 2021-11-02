const { hardhatArguments } = require("hardhat");
const hre = require("hardhat");

async function main() {
  const ValTracker = await hre.ethers.getContractFactory("ValorantTracker");
  const val = await ValTracker.deploy();

  console.log("Deploying Valorant Tracker...");
  await val.deployed();

  console.log("Valorant Tracker deployed to:", val.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.log(error);
    process.exit(1);
  });
