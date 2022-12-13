import { expect } from 'chai';
import { ethers } from 'hardhat';

describe.only('RandomGame TEST', async () => {
	let Descriptor: any;
	let descriptor: any;

	let RandomGame: any;
	let randomGame: any;

	const playerLimit = 100;
	const price = ethers.utils.parseEther('10');

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
		expect(testData1).to.equal('0x0000000000000000000000000000000000000000');

		const testData2 = await randomGame.getWinnerList(2);
		expect(testData2).to.equal('0x0000000000000000000000000000000000000000');

		const testData3 = await randomGame.getWinnerList(3);
		expect(testData3).to.equal('0x0000000000000000000000000000000000000000');
	});

	it('should get player data', async () => {
		const testData = await randomGame.getPlayerData(0);
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

	it('should reject set player (game is not started)', async () => {
		await expect(
			randomGame.setPlayerData(2, referalAddress1, {
				value: ethers.utils.parseEther('20'),
			})
		).to.be.revertedWith('game is not started');
	});

	it('should start the real game', async () => {
		const testDataEvent = await randomGame.startGame(5);
		await testDataEvent.wait();

		const testData = await randomGame.isGameStart();
		expect(testData).to.equal(true);
	});

	it('should reject set player (not enough coin)', async () => {
		await expect(
			randomGame.setPlayerData(5, referalAddress1, {
				value: ethers.utils.parseEther('10'),
			})
		).to.be.revertedWith('not enough coin');
	});

	it('should set test player 1', async () => {
		const testDataEvent = await randomGame.setPlayerData(3, referalAddress1, {
			value: ethers.utils.parseEther('30'),
		});
		await testDataEvent.wait();

		const testData = await randomGame.getPlayerData(0);
		expect(testData).to.not.equal('0x0000000000000000000000000000000000000000');
	});

	it('should set test player 2', async () => {
		const testDataEvent = await randomGame.setPlayerData(1, referalAddress1, {
			value: ethers.utils.parseEther('10'),
		});
		await testDataEvent.wait();

		const testData = await randomGame.getPlayerData(3);
		expect(testData).to.be.a('string');
	});

	it('should set test player 3', async () => {
		const testDataEvent = await randomGame.setPlayerData(1, referalAddress1, {
			value: ethers.utils.parseEther('10'),
		});
		await testDataEvent.wait();

		const testData = await randomGame.getPlayerData(4);
		expect(testData).to.be.a('string');
	});

	it('should reject set player (player limit reach)', async () => {
		await expect(
			randomGame.setPlayerData(1, referalAddress1, {
				value: ethers.utils.parseEther('10'),
			})
		).to.be.revertedWith('player limit reach');
	});

	it('should set the winner', async () => {
		const testDataEvent = await randomGame.setWinner(1);
		await testDataEvent.wait();

		const testData1 = await randomGame.isGameStart();
		expect(testData1).to.equal(false);

		const testData2 = await randomGame.getWinnerList(1);
		expect(testData2).to.be.a('string');
	});

	it('should get the winner list', async () => {
		const testData1 = await randomGame.getWinnerList(1);
		expect(testData1).to.be.a('string');

		const testData2 = await randomGame.getWinnerList(2);
		expect(testData2).to.equal(referalAddress2);

		const testData3 = await randomGame.getWinnerList(3);
		expect(testData3).to.equal(referalAddress2);
	});

	it('should start another real game', async () => {
		const testDataEvent = await randomGame.startGame(3);
		await testDataEvent.wait();

		const testData1 = await randomGame.getPlayerCount();
		expect(testData1).to.equal(0);

		const testData2 = await randomGame.getPlayerLimit();
		expect(testData2).to.equal(3);

		const testData3 = await randomGame.isGameStart();
		expect(testData3).to.equal(true);

		const testData = await randomGame.getPlayerData(0);
		expect(testData).to.equal('0x0000000000000000000000000000000000000000');
	});
});
