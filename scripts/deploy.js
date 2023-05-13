const { ethers } = require("hardhat");
require("dotenv").config({ path: ".env" });

async function main() {
  const verifyContract = await ethers.getContractFactory("Token");

  const deployedVerifyContract = await verifyContract.deploy();

  await deployedVerifyContract.deployed();

  console.log("Token Contract Address:", deployedVerifyContract.address);

  console.log("Sleeping.....");
  await sleep(40000);

  await hre.run("verify:verify", {
    address: deployedVerifyContract.address,
    constructorArguments: [],
  });
}

async function Managers() {
  const verifyContract = await ethers.getContractFactory("AdManager");
  const deployedVerifyContract = await verifyContract.deploy(
    "0xC3990AbC1bc52Dd2751dE6696E1f88c4Eef0a7aF"
  );
  console.log("MarketPlace Contract Address:", deployedVerifyContract.address);
  console.log("Sleeping.....");
  await sleep(40000);

  await hre.run("verify:verify", {
    address: deployedVerifyContract.address,
    constructorArguments: ["0xC3990AbC1bc52Dd2751dE6696E1f88c4Eef0a7aF"],
  });
}

function sleep(ms) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

Managers()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });

// main()
//   .then(() => process.exit(0))
//   .catch((error) => {
//     console.error(error);
//     process.exit(1);
//   });
