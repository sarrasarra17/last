const Migrations = artifacts.require("Migrations");

module.exports = function(deployer) {
  deployer.deploy(Migrations)
    .then(() => console.log("Migrations deployed successfully"))
    .catch((error) => console.error("Deployment failed", error));
};
