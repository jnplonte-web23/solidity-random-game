// import { expect } from 'chai';
// import { ethers } from 'hardhat';

// describe.only('Test TEST', async () => {
// 	let TestDescriptor: any;
// 	let testdescriptor: any;

// 	let Web23Descriptor: any;
// 	let web23descriptor: any;

// 	let Test: any;
// 	let test: any;

// 	before(async () => {
// 		TestDescriptor = await ethers.getContractFactory('TestDescriptor');
// 		testdescriptor = await TestDescriptor.deploy();
// 		testdescriptor.deployed();

// 		Web23Descriptor = await ethers.getContractFactory('Web23Descriptor');
// 		web23descriptor = await Web23Descriptor.deploy();
// 		web23descriptor.deployed();

// 		Test = await ethers.getContractFactory('Test');
// 		test = await Test.deploy(testdescriptor.address);
// 		test.deployed();
// 	});

// 	it('should return testData default value', async () => {
// 		const testData = await test.getTestData();
// 		expect(testData).to.equal('TEST');
// 	});

// 	it('should change testData value', async () => {
// 		await test.setTestData('SUPER ABC');

// 		const testData = await test.getTestData();
// 		expect(testData).to.equal('SUPER ABC');
// 	});

// 	it('should change descriptor address', async () => {
// 		await test.setDescriptor(web23descriptor.address);

// 		const testData = await test.getTestData();
// 		expect(testData).to.equal('WEB23');
// 	});

// 	it('should change testData value', async () => {
// 		await test.setTestData('SUPER DEF');

// 		const testData = await test.getTestData();
// 		expect(testData).to.equal('SUPER DEF - FROM WEB23');
// 	});
// });
