const InsurancePolicy = artifacts.require("InsurancePolicy");

module.exports = function (deployer) {
  deployer.deploy(InsurancePolicy);
};



