import { ethers } from 'hardhat';

async function main() {
	// Hardhat always runs the compile task when running scripts with its command
	// line interface.
	//
	// If this script is run directly using `node` you may want to call compile
	// manually to make sure everything is compiled
	// await hre.run('compile');

	const playerLimit = 100;
	const price = ethers.utils.parseEther('0.1');

	const [deployer] = await ethers.getSigners(); // get the account to deploy the contract
	console.log('deploying random game contract with the account:', deployer.address);
	console.log('account balance:', (await deployer.getBalance()).toString());

	try {
		const RandomGameDescriptor = await ethers.getContractFactory('RandomGameDescriptor');
		const randomGameDescriptor = await RandomGameDescriptor.deploy();
		await randomGameDescriptor.deployed();
		console.log('random game descriptor deployed to:', randomGameDescriptor.address);

		const RandomGame = await ethers.getContractFactory('RandomGame');
		const randomGame = await RandomGame.deploy(randomGameDescriptor.address, playerLimit, price);
		await randomGame.deployed();
		console.log('random game contract deployed to:', randomGame.address);
	} catch (error) {
		throw new Error(`try catch error: ${JSON.stringify(error)}`);
	}
}

main()
	.then(() => process.exit(0))
	.catch((error) => {
		console.error(`randomGame contract error: ${JSON.stringify(error)}`);
		process.exit(1);
	});
