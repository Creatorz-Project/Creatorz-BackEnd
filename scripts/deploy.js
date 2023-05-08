const { ethers } = require("hardhat");

let address;

async function token() {
  const tokenFactory = await ethers.getContractFactory("Token");
  const token = await tokenFactory.deploy();
  await token.deployed();
  console.log("Token deployed to:", token.address);
  address = token.address;
  const tx = await token.mintVideo("karthikeya", ethers.utils.parseEther("1"));
  await tx.wait;
  console.log("Video minted");
}

async function Manager() {
  const AdFactory = await ethers.getContractFactory("AdManager");
  const Ad = await AdFactory.deploy(address);
  await Ad.deployed();
  console.log("Ad deployed to:", Ad.address);
  await Ad.getVideo(ethers.utils.parseEther("0")).then((res) => {
    console.log(res);
  });
}

token()
  .then(() => {
    console.log("Token deployed");
    Manager();
  })
  .catch((e) => {
    console.error(e);
    process.exit(1);
  });
