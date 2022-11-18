import { expect } from 'chai';
import { ethers } from 'hardhat';

describe.only('RandomGame TEST', async () => {
	let Descriptor: any;
	let descriptor: any;

	let RandomGame: any;
	let randomGame: any;

	const playerLimit = 100;
	const price = ethers.utils.parseEther('0.1');

	const referalAddress1: string = '0x58933D8678b574349bE3CdDd3de115468e8cb3f0';
	const referalAddress2: string = '0x0000000000000000000000000000000000000000';

	const address1: string = '0x58933D8678b574349bE3CdDd3de115468e8cb3f0';
	const address2: string = '0x30eDEc1C25218F5a748cccc54C562d7879e47CaA';
	const address3: string = '0xB07243398f1d0094b64f4C0a61B8C03233914036';

	before(async () => {
		Descriptor = await ethers.getContractFactory('RandomGameDescriptor');
		descriptor = await Descriptor.deploy();
		descriptor.deployed();

		RandomGame = await ethers.getContractFactory('RandomGame');
		randomGame = await RandomGame.deploy(descriptor.address, playerLimit, price);
		randomGame.deployed();
	});

	it('should get price', async () => {
		const testData = await randomGame.getPrice();
		expect(testData).to.equal(price);
	});

	it('should get player limit', async () => {
		const testData = await randomGame.getPlayerLimit();
		expect(testData).to.equal(playerLimit);
	});

	it('should get player count', async () => {
		const testData = await randomGame.getPlayerCount();
		expect(testData).to.equal(0);
	});

	it('should get game start', async () => {
		const testData = await randomGame.getGameStart();
		expect(testData).to.equal(false);
	});

	it('should get winner list', async () => {
		const testData = await randomGame.getWinnerList(1);
		expect(testData.length).to.equal(0);
	});

	it('should get player data', async () => {
		const testData = await randomGame.getPlayerData(1);
		expect(testData).to.equal('0x0000000000000000000000000000000000000000');
	});
});
