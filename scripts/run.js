const { ethers } = require("hardhat");

const main = async () => {
  const waveContractFactory = await hre.ethers.getContractFactory("MyEpicNFT");
  const nftContract = await waveContractFactory.deploy();
  await nftContract.deployed();

  // console.log("Contract deployed to: ", nftContract.address);
  // console.log("Contract deployed by: ", owner.address);

  await nftContract.getTotalNFTsMintedSoFar();
  let txn = await nftContract.makeAnEpicNFT({
    value: ethers.utils.parseEther("0.001"),
  });
  await txn.wait();
  let balance = await nftContract.provider.getBalance(nftContract.address);
  console.log(ethers.utils.formatEther(balance));
  // const account = await ethers.getSigners();
  // const connectedContract = await nftContract.connect(account[1]);
  // await connectedContract.withdraw();
  // balance = await nftContract.provider.getBalance(nftContract.address);
  // console.log(ethers.utils.formatEther(balance));
};

const runMain = async () => {
  try {
    await main();
    process.exit(0); // exit Node process without error
  } catch (error) {
    console.log(error);
    process.exit(1); // exit Node process while indicating 'Uncaught Fatal Exception' error
  }
  // Read more about Node exit ('process.exit(num)') status codes here: https://stackoverflow.com/a/47163396/7974948
};

runMain();
