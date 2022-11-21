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

	it('should get contract balance', async () => {
		const testData = await randomGame.getBalance();

		expect(Number(testData)).to.equal(0);
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

	it('should check if game is started', async () => {
		const testData = await randomGame.isGameStart();
		expect(testData).to.equal(false);
	});

	it('should get winner list', async () => {
		const testData1 = await randomGame.getWinnerList(1);
		expect(testData1.length).to.equal(0);

		const testData2 = await randomGame.getWinnerList(2);
		expect(testData2.length).to.equal(0);

		const testData3 = await randomGame.getWinnerList(3);
		expect(testData3.length).to.equal(0);
	});

	it('should get player data', async () => {
		const testData = await randomGame.getPlayerData(1);
		expect(testData).to.equal('0x0000000000000000000000000000000000000000');
	});

	it('should start game', async () => {
		const testDataEvent = await randomGame.startGame(222);
		await testDataEvent.wait();

		const testData1 = await randomGame.getPlayerCount();
		expect(testData1).to.equal(0);

		const testData2 = await randomGame.getPlayerLimit();
		expect(testData2).to.equal(222);

		const testData3 = await randomGame.isGameStart();
		expect(testData3).to.equal(true);
	});

	it('should stop game', async () => {
		const testDataEvent = await randomGame.stopGame();
		await testDataEvent.wait();

		const testData = await randomGame.isGameStart();
		expect(testData).to.equal(false);
	});

	it('should start the real game', async () => {
		const testDataEvent = await randomGame.startGame(10);
		await testDataEvent.wait();

		const testData = await randomGame.isGameStart();
		expect(testData).to.equal(true);
	});
});
