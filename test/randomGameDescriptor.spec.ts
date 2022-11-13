import { expect } from 'chai';
import { ethers } from 'hardhat';

describe.only('RandomGameDescriptor TEST', async () => {
	let RandomGameDescriptor: any;
	let descriptor: any;

	const address1: string = '0x58933D8678b574349bE3CdDd3de115468e8cb3f0';
	const address2: string = '0x30eDEc1C25218F5a748cccc54C562d7879e47CaA';
	const address3: string = '0xB07243398f1d0094b64f4C0a61B8C03233914036';

	before(async () => {
		RandomGameDescriptor = await ethers.getContractFactory('RandomGameDescriptor');
		descriptor = await RandomGameDescriptor.deploy();
		descriptor.deployed();
	});

	it('should get random number', async () => {
		const testData = await descriptor.getRandomNumber(1, 1, 3);

		expect(Number(testData.toString())).to.be.a('number');
	});

	it('should set test player', async () => {
		await descriptor.setPlayerData(1, address1);
		await descriptor.setPlayerData(2, address2);
		await descriptor.setPlayerData(3, address3);

		const testData1 = await descriptor.getPlayerData(1);
		expect(testData1).to.equal(address1);
	});

	it('should get test player', async () => {
		const testData2 = await descriptor.getPlayerData(2);
		expect(testData2).to.equal(address2);

		const testData3 = await descriptor.getPlayerData(3);
		expect(testData3).to.equal(testData3);
	});

	it('should set and get token start', async () => {
		await descriptor.setTokenStart(1);

		const testData = await descriptor.getTokenStart();
		expect(testData).to.equal(1);
	});

	it('should set the winner', async () => {
		const testData = await descriptor.setWinner(3);

		expect(testData.length).to.equal(3);
		expect(testData.includes(address1)).to.be.true;
	});
});
