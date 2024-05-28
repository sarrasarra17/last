const HandymanContract = artifacts.require("HandymanContract");

module.exports = function(deployer) {
  deployer.deploy(HandymanContract);
};
