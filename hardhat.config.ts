import * as dotenv from 'dotenv';

import { HardhatUserConfig, task } from 'hardhat/config';
import '@nomiclabs/hardhat-etherscan';
import '@nomiclabs/hardhat-waffle';
import '@typechain/hardhat';
import 'hardhat-gas-reporter';
import 'solidity-coverage';

dotenv.config();

// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task('accounts', 'Prints the list of accounts', async (taskArgs, hre) => {
	const accounts = await hre.ethers.getSigners();

	for (const account of accounts) {
		console.log(account.address);
	}
});

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

const config: HardhatUserConfig = {
	defaultNetwork: 'hardhat',
	solidity: {
		compilers: [
			{
				version: '0.8.11',
				settings: {
					optimizer: {
						enabled: true,
						runs: 200,
					},
				},
			},
		],
	},
	networks: {
		[process.env.ETHEREUM_NETWORK as string]: {
			url: process.env.ETHEREUM_URL || '',
			accounts: process.env.PRIVATE_KEY !== undefined ? [process.env.PRIVATE_KEY] : [],
		},
	},
	gasReporter: {
		enabled: process.env.REPORT_GAS !== undefined && process.env.REPORT_GAS == '1',
		showTimeSpent: true,
		token: 'ETH',
		gasPriceApi: 'https://api.etherscan.io/api?module=proxy&action=eth_gasPrice',
		currency: 'USD',
		coinmarketcap: process.env.COINMARKETCAP_API_KEY,
	},
	etherscan: {
		apiKey: process.env.ETHERSCAN_API_KEY,
	},
	typechain: {
		outDir: "build/typechain",
		target: "ethers-v5",
		alwaysGenerateOverloads: false,
		externalArtifacts: ["externalArtifacts/*.json"]
	}
};

export default config;
