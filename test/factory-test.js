const { artifacts, assert } = require("hardhat");
const {
  TIME_PERIODS,
  AMOUNTS,
  BENEFICIARY,
  TOKEN,
  OWNER,
} = require("../calc.js");

const Factory = artifacts.require("Factory.sol");
const TokenVesting = artifacts.require("TokenVesting");
const IERC20 = artifacts.require("contracts/Vesting.sol:IERC20");

let factory, vestingAddress;

beforeEach(async function () {
  factory = await Factory.new();
  await factory.createVestingInstance(
    TIME_PERIODS,
    AMOUNTS,
    BENEFICIARY,
    TOKEN,
    OWNER
  );
});
contract("Factory Testing", function (accounts) {
  it("adds to mapping", async function () {
    vestingAddress = await factory.userToVesting(accounts[0]);
    assert.notEqual(vestingAddress, "0x".padEnd(42, 0));
  });
  it("deploys with correct data", async function () {
    vestingAddress = await factory.userToVesting(accounts[0]);
    const tokenVesting = await TokenVesting.at(vestingAddress);
    const data = await tokenVesting.getGlobalData();
    assert.equal(data.totalPeriods, TIME_PERIODS.length);
    assert.equal(data.totalReleased, 0);
  });
  it("releases tokens correctly", async function () {
    vestingAddress = await factory.userToVesting(accounts[0]);
    const tokenVesting = await TokenVesting.at(vestingAddress);
    const token = await IERC20.at(TOKEN);
    const balance = await token.balanceOf(accounts[0]);
    console.log(
      "my wallet balance:",
      web3.utils.fromWei(balance.toString(), "ether"),
      "$DMT"
    );
    await token.transfer(vestingAddress, balance.toString());
    const contractBalance = await token.balanceOf(vestingAddress);
    console.log(
      "tokens transferred to contract, contract balance:",
      web3.utils.fromWei(contractBalance.toString(), "ether"),
      "$DMT"
    );
    console.log("attempting to release...");
    await tokenVesting.release();
    const newBalance = await token.balanceOf(accounts[0]);
    console.log(
      "release successfull, wallet balance:",
      web3.utils.fromWei(newBalance.toString(), "ether"),
      "$DMT"
    );
  });
});
