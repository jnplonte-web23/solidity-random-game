import { expect } from 'chai';
import { ethers } from 'hardhat';

describe.only('RandomGameDescriptor TEST', async () => {
	let RandomGameDescriptor: any;
	let descriptor: any;

	const referalAddress1: string = '0x58933D8678b574349bE3CdDd3de115468e8cb3f0';
	const referalAddress2: string = '0x0000000000000000000000000000000000000000';

	const address1: string = '0x58933D8678b574349bE3CdDd3de115468e8cb3f0';
	const address2: string = '0x30eDEc1C25218F5a748cccc54C562d7879e47CaA';
	const address3: string = '0xB07243398f1d0094b64f4C0a61B8C03233914036';

	before(async () => {
		RandomGameDescriptor = await ethers.getContractFactory('RandomGameDescriptor');
		descriptor = await RandomGameDescriptor.deploy();
		descriptor.deployed();
	});

	it('should get random number', async () => {
		const testData = await descriptor.getRandomNumber(1, 0, 3);

		expect(Number(testData.toString())).to.be.a('number');
	});

	it('should set test player 1', async () => {
		const testDataEvent = await descriptor.setPlayerData(0, address1, referalAddress1);
		await testDataEvent.wait();

		const testData = await descriptor.getPlayerData(0);
		expect(testData).to.equal(address1);
	});

	it('should set test player 2', async () => {
		const testDataEvent = await descriptor.setPlayerData(1, address2, referalAddress1);
		await testDataEvent.wait();

		const testData = await descriptor.getPlayerData(1);
		expect(testData).to.equal(address2);
	});

	it('should set test player 3', async () => {
		const testDataEvent = await descriptor.setPlayerData(2, address3, referalAddress1);
		await testDataEvent.wait();

		const testData = await descriptor.getPlayerData(2);
		expect(testData).to.equal(address3);
	});

	it('should set the winner', async () => {
		const testData1 = await descriptor.setWinner(2, 3);

		expect(testData1[0].length).to.equal(3);
		expect(testData1[1].length).to.equal(3);
	});

	it('should clear player data', async () => {
		const testDataEvent = await descriptor.clearPlayerData(100);
		await testDataEvent.wait();

		const testData1 = await descriptor.getPlayerData(0);
		expect(testData1).to.equal(referalAddress2);

		const testData2 = await descriptor.getPlayerData(1);
		expect(testData2).to.equal(referalAddress2);

		const testData3 = await descriptor.getPlayerData(2);
		expect(testData3).to.equal(referalAddress2);
	});
});
