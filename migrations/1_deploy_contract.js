var createCertificate = artifacts.require("CreateCertificate");

module.exports = function (deployer) {
  deployer.deploy(createCertificate);
};
