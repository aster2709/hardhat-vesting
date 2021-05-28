require("@nomiclabs/hardhat-truffle5");

// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async () => {
  const accounts = await ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  solidity: "0.7.3",
  networks: {
    rinkeby: {
      url: "https://rinkeby.infura.io/v3/98667df842b643c5a68077377ac327a2",
      accounts: {
        mnemonic:
          "laugh end deputy believe social witness soccer master protect skill carpet warrior",
      },
    },
  },
  mocha: {
    timeout: 60000,
  },
};