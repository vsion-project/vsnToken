const hre = require("hardhat");

const fs = require("fs");

async function main() {
  const getDigitalMarketplace = await hre.ethers.getContractFactory("VSION");
  const digitalMarketplace = await getDigitalMarketplace.deploy();
  await digitalMarketplace.deployed();
  console.log("VSION TOKEN deployed to:", digitalMarketplace.address);
  /* await hre.run("verify:verify", {
    address: digitalMarketplace.address,
    contract:
      "contracts/DigitalMarketplacePayment.sol:DigitalMarketplacePayment", //
    constructorArguments: [],
  });
  
  
  const getDeerToken = await hre.ethers.getContractFactory("DeerToken");
  const deerToken = await getDeerToken.deploy();
  await deerToken.deployed();
  console.log("deerToken deployed to:", deerToken.address);

  await hre.run("verify:verify", {
    address: deerToken.address,
    contract: "contracts/DeerToken.sol:DeerToken", //DeerToken.sol:ClassName
    constructorArguments: [],
  });


  const getInterestTokenDeer = await hre.ethers.getContractFactory(
    "InterestTokenDeer"
  );
  const deerInterestToken = await getInterestTokenDeer.deploy(
    "0xfD2d183C2402F117BA622195a75686663f4d55Ad"
  );
  await deerInterestToken.deployed();
  console.log("deerInterestToken deployed to:", deerInterestToken.address);

  await hre.run("verify:verify", {
    address: deerInterestToken.address,
    contract: "contracts/InterestTokenDeer.sol:InterestTokenDeer", //DeerToken.sol:ClassName
    constructorArguments: ["0xfD2d183C2402F117BA622195a75686663f4d55Ad"],
  }); 




  const getDeerLock = await hre.ethers.getContractFactory("DeerLock");
  const deerLock = await getDeerLock.deploy(
    "0xbff97F78a594c2a65eFBe7b46fCb8D30406d8f6b",
    "0xfD2d183C2402F117BA622195a75686663f4d55Ad"
  );
  await deerLock.deployed();
  console.log("deerLock deployed to:", deerLock.address);

  await hre.run("verify:verify", {
    address: deerLock.address,
    contract: "contracts/DeerLock.sol:DeerLock", //DeerToken.sol:ClassName
    constructorArguments: [
      "0xbff97F78a594c2a65eFBe7b46fCb8D30406d8f6b",
      "0xfD2d183C2402F117BA622195a75686663f4d55Ad",
    ],
  });
  */
  let config = `
  export const digitalMarketplace = "${digitalMarketplace.address}"
  `;

  let data = JSON.stringify(config);
  fs.writeFileSync("config.js", JSON.parse(data));
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
