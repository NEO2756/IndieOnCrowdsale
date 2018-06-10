

var IndieToken = artifacts.require("./IndieToken.sol");
var IndieOnCrowdSale = artifacts.require("./IndieOnCrowdSale.sol");

function latestTime() {
  return web3.eth.getBlock('latest').timestamp;
}

const duration = {
  seconds: function(val) { return val},
  minutes: function(val) { return val * this.seconds(60) },
  hours:   function(val) { return val * this.minutes(60) },
  days:    function(val) { return val * this.hours(24) },
  weeks:   function(val) { return val * this.days(7) },
  years:   function(val) { return val * this.days(365)}
};
const startTime = latestTime() + duration.minutes(1);
const endTime =  startTime + duration.minutes(10);

module.exports = function(deployer) {
    deployer.deploy(IndieToken).then (async () => {
      const instance  = await IndieToken.deployed();
      console.log(instance.address);
      return deployer.deploy(1, "0xbb6e597ef5c28256bd3d9f4f9e222859ca242d20", instance.address, startTime, endTime);
    })
  }

  //return liveDeploy(deployer, accounts);
//};
//

//
// async function liveDeploy(deployer, accounts) {
//   const BigNumber = web3.BigNumber;
//   const RATE = 1;
//   const startTime = latestTime() + duration.minutes(1);
//   const endTime =  startTime + duration.minutes(5);
//   console.log([startTime, endTime, RATE, accounts[0]]);
//   // uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet)
//
//   return deployer.deploy(IndieToken).then( async () => {
//     const instance = await IndieToken.deployed();
//     const token = await instance.token.call();
//     console.log('Token Address', token);
//   })
// }
