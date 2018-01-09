var fs = require('fs');
var FreeCoin = artifacts.require("./FreeCoin.sol");

module.exports = function(deployer, network) {
  if (network === 'develop') {
    deployer.deploy(FreeCoin).then(_ => {
      fs.writeFileSync('./freecoin.address', FreeCoin.address);
    });
  } else {
    throw new Error('Not ready to deploy outside of dev.')
  }
};
