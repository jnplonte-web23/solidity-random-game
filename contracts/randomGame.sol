// SPDX-License-Identifier: MIT

pragma solidity ^0.8.11;

import '@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol';
import '@openzeppelin/contracts/access/Ownable.sol';
import '@openzeppelin/contracts/utils/Counters.sol';

import { IRandomGameDescriptor } from './interfaces/IRandomGameDescriptor.sol';

contract RandomGame is Ownable, ERC721Enumerable {
	using Counters for Counters.Counter;

	IRandomGameDescriptor public randomGameDescriptor;

	uint256 public playerLimit;
	uint256 public playerCount;
	uint256 public price;

	Counters.Counter private tokenCount;

	/***
	 * @notice constructor
	 * @param _randomGameDescriptor address for test descriptor
	 * @param _playerLimit limit of the player that allowed to join
	 * @param _price entry price
	 */
	constructor(
		address _randomGameDescriptor,
		uint256 _playerLimit,
		uint256 _price
	) ERC721('RandomGame for Web23', 'RANDOMGAME') {
		randomGameDescriptor = IRandomGameDescriptor(_randomGameDescriptor);

		playerLimit = _playerLimit;
		playerCount = 0;
		price = _price;
	}

	/**
	 * @notice get price
	 */
	function getPrice() public view returns (uint256) {
		return price;
	}

	/**
	 * @notice set price
	 * @param _price entry price
	 */
	function setPrice(uint256 _price) public onlyOwner {
		price = _price;
	}

	/**
	 * @notice get player limit
	 */
	function getPlayerLimit() public view returns (uint256) {
		return playerLimit;
	}

	/**
	 * @notice set player limit
	 * @param _playerLimit limit of the player that allowed to join
	 */
	function setPlayerLimit(uint256 _playerLimit) public onlyOwner {
		playerLimit = _playerLimit;
	}

	/**
	 * @notice get token start
	 */
	function getTokenStart() public view returns (uint256) {
		return randomGameDescriptor.getTokenStart();
	}

	/**
	 * @notice start new game
	 */
	function startGame() public onlyOwner {
		playerCount = 0;
		randomGameDescriptor.setTokenStart(tokenCount.current());
	}

	/**
	 * @notice get player data
	 * @param _tokenId token id
	 */
	function getPlayerData(uint256 _tokenId) public view returns (address) {
		require(_exists(_tokenId), 'token dosent exists');

		return randomGameDescriptor.getPlayerData(_tokenId);
	}

	/**
	 * @notice set the new descriptor
	 * @param _randomGameDescriptor address for test descriptor
	 */
	function setDescriptor(address _randomGameDescriptor) public onlyOwner {
		require(_randomGameDescriptor != address(0), 'INVALID_ADDRESS');
		randomGameDescriptor = IRandomGameDescriptor(_randomGameDescriptor);
	}

	/**
	 * @notice set the player data
	 */
	function setPlayerData() public payable {
		require(msg.value >= price, 'not enough coin');
		require(playerLimit >= playerCount, 'limit reach');

		address playerAddress = msg.sender;

		_safeMint(playerAddress, tokenCount.current());
		randomGameDescriptor.setPlayerData(tokenCount.current(), playerAddress);

		playerCount = playerCount + 1;
		tokenCount.increment();
	}

	/**
	 * @notice set winner
	 */
	function setWinner() public view onlyOwner returns (address) {
		return randomGameDescriptor.setWinner(tokenCount.current());
	}
}
