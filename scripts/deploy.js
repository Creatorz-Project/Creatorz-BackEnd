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
    "0x0f1995C01973947097a9fd1489822716b9C0B044"
  );
  console.log("MarketPlace Contract Address:", deployedVerifyContract.address);
  console.log("Sleeping.....");
  await sleep(40000);

  await hre.run("verify:verify", {
    address: deployedVerifyContract.address,
    constructorArguments: ["0x0f1995C01973947097a9fd1489822716b9C0B044"],
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
