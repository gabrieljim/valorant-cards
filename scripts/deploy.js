const { parseEther } = require("ethers/lib/utils");
const { hardhatArguments } = require("hardhat");
const hre = require("hardhat");

async function main() {
  const ValCards = await hre.ethers.getContractFactory("ValorantCards");

  let linkAddresses;
  switch (hardhatArguments.network) {
    case "kovan":
      linkAddresses = {
        coordinator: "0xdD3782915140c8f3b190B5D67eAc6dc5760C46E9",
        token: "0xa36085F69e2889c224210F603D836748e7dC0088",
        hash: "0x6c3699283bda56ad74f6b855546325b68d482e983852a7a82979cc4807b641f4",
        oracle: "0xc57B33452b4F7BB189bB5AfaE9cc4aBa1f7a4FD8",
        jobId:
          "0x6435323730643163333131393431643062303862656164323166656137373437",
        oracleFee: parseEther("0.1"),
      };
      break;
    default:
      return;
  }

  const val = await ValCards.deploy(
    linkAddresses.coordinator,
    linkAddresses.token,
    linkAddresses.hash,
    linkAddresses.oracle,
    linkAddresses.jobId,
    linkAddresses.oracleFee
  );

  console.log("Deploying Valorant Cards...");
  await val.deployed();

  console.log("Valorant Cards deployed to:", val.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.log(error);
    process.exit(1);
  });
