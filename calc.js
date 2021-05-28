const {
  startTime,
  numOfintervals,
  totalAmount,
  intervalGap,
  token,
  beneficiary,
  owner,
} = require("./config.json");

const TIME_PERIODS = Array(+numOfintervals)
  .fill()
  .map((_, i) => {
    return (+startTime + i * +intervalGap).toString();
  });

const AMOUNTS = Array(+numOfintervals)
  .fill()
  .map((_, i) => {
    const percent20 = 0.2 * totalAmount;
    const temp = i
      ? (totalAmount - percent20) / (numOfintervals - 1)
      : percent20;
    return temp.toString().padEnd(temp.length, 0);
  });

const BENEFICIARY = beneficiary;
const TOKEN = token;
const OWNER = owner;

module.exports = {
  TIME_PERIODS,
  AMOUNTS,
  BENEFICIARY,
  TOKEN,
  OWNER,
};
