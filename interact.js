const Web3 = require('web3');
const contract = require('@truffle/contract');
const fs = require('fs');

// Read the HandymanContract JSON artifact
const HandymanContractArtifact = JSON.parse(fs.readFileSync('./build/contracts/HandymanContract.json', 'utf8'));

// Connect to the local Ethereum node (e.g., Ganache)
const web3 = new Web3(new Web3.providers.HttpProvider('http://127.0.0.1:8545'));

const HandymanContract = contract(HandymanContractArtifact);
HandymanContract.setProvider(web3.currentProvider);

async function bookService() {
  const accounts = await web3.eth.getAccounts();
  const account = accounts[0];

  const instance = await HandymanContract.deployed();

  try {
    await instance.bookService(
      "John Doe",
      "johndoe@example.com",
      "Plumbing",
      "2024-06-01",
      "10:00 AM",
      { from: account }
    );
    console.log("Service booked successfully!");
  } catch (error) {
    console.error("Error booking service:", error);
  }
}

async function getBookings() {
  const instance = await HandymanContract.deployed();

  try {
    const bookings = await instance.getBookings();
    console.log("Bookings:", bookings);
  } catch (error) {
    console.error("Error getting bookings:", error);
  }
}

bookService().then(() => getBookings());
