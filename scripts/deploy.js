const main = async () => {
  const nftFactory = await hre.ethers.getContractFactory("MyEpicNFT");
  const nftContract = await nftFactory.deploy();
  await nftContract.deployed();
  console.log("NFT ADDRESS: ", nftContract.address);

  // let txn = await nftContract.makeAnEpicNFT();
  // // Wait for it to be mined.
  // await txn.wait();
  // console.log("Minted NFT #1");
};

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.error(error);
    process.exit(1);
  }
};

runMain();
