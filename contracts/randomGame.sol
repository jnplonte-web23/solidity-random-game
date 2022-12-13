// SPDX-License-Identifier: MIT

pragma solidity ^0.8.16;

import '@openzeppelin/contracts/access/Ownable.sol';
import 'hardhat/console.sol';

import './hedera/HederaTokenService.sol';
import './hedera/HederaResponseCodes.sol';

import { IRandomGameDescriptor } from './interfaces/IRandomGameDescriptor.sol';

contract RandomGame is HederaTokenService, Ownable {
	event SetPlayer(address indexed playerAddress, uint256 playerCount, uint8 count);
	event SetWinner(address indexed finalWinner1, address indexed finalWinner2, address indexed finalWinner3);

	IRandomGameDescriptor public randomGameDescriptor;

	struct PlayerStruct {
		address playerAddress;
		address referalAddress;
		bool active;
	}

	uint256 private constant GAMEENDTIME = 864000; // 10 days

	// NOTE: 10 percent goes to the contract
	uint8 private constant REFERALFEE = 5;
	uint8 private constant WINNER1FEE = 50;
	uint8 private constant WINNER2FEE = 20;
	uint8 private constant WINNER3FEE = 15;

	bool private gameStart; // game start true or false
	uint256 private gameStartTime = 0; // game start time based on block.timestamp

	uint256 private playerLimit;
	uint256 private playerCount;
	uint256 private price;

	address[] private winner1List;
	address[] private winner2List;
	address[] private winner3List;

	/***
	 * @notice constructor
	 * @param _randomGameDescriptor address for test descriptor
	 * @param _playerLimit limit of the player that allowed to join
	 * @param _price entry price
	 */
	constructor(address _randomGameDescriptor, uint256 _playerLimit, uint256 _price) {
		randomGameDescriptor = IRandomGameDescriptor(_randomGameDescriptor);

		playerLimit = _playerLimit;
		playerCount = 0;
		price = _price;
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
	 * @notice transfer hbar
	 * @param _receiverAddress address of receiver
	 * @param _amount amount of token
	 */
	function transferHbar(address payable _receiverAddress, uint _amount) public onlyOwner {
		_receiverAddress.transfer(_amount);
	}

	/**
	 * @notice get contract balance
	 */
	function getBalance() public view onlyOwner returns (uint256) {
		return address(this).balance;
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
	 * @notice get current player count
	 */
	function getPlayerCount() public view returns (uint256) {
		return playerCount;
	}

	/**
	 * @notice is game started
	 */
	function isGameStart() public view returns (bool) {
		return gameStart;
	}

	/**
	 * @notice start new game
	 * @param _playerLimit limit of the player that allowed to join
	 */
	function startGame(uint256 _playerLimit) public onlyOwner {
		gameStart = true;
		gameStartTime = block.timestamp + GAMEENDTIME;

		playerCount = 0;
		playerLimit = _playerLimit;
		randomGameDescriptor.clearPlayerData(_playerLimit);
	}

	/**
	 * @notice stop game
	 */
	function stopGame() public onlyOwner {
		gameStart = false;
	}

	/**
	 * @notice get player data
	 * @param _tokenId token id
	 */
	function getPlayerData(uint256 _tokenId) public view returns (address) {
		return randomGameDescriptor.getPlayerData(_tokenId);
	}

	/**
	 * @notice set the player data
	 * @param _referalAddress referal address
	 * @param _count number of entries
	 */
	function setPlayerData(uint8 _count, address _referalAddress) public payable {
		require(gameStart == true, 'game is not started');
		require(gameStartTime >= block.timestamp, 'game expired');
		require(msg.value >= price * _count, 'not enough coin');
		require(playerLimit >= playerCount + _count, 'player limit reach');

		address playerAddress = msg.sender;

		uint8 j = 1;
		for (j; j <= _count; j++) {
			randomGameDescriptor.setPlayerData(playerCount, playerAddress, _referalAddress);
			playerCount = playerCount + 1;
		}

		emit SetPlayer(playerAddress, playerCount, _count);
	}

	/**
	 * @notice set winner
	 * @param _winnerCount winner count (max 3)
	 */
	function setWinner(uint8 _winnerCount) public onlyOwner {
		stopGame();

		address[3] memory winners;
		address[3] memory referals;
		(winners, referals) = randomGameDescriptor.setWinner(playerCount, _winnerCount);

		transferHbar(payable(address(winners[0])), price);

		if (_winnerCount >= 2) {
			transferHbar(payable(address(winners[1])), price);
		}

		if (_winnerCount >= 3) {
			transferHbar(payable(address(winners[2])), price);
		}

		winner1List.push(address(winners[0]));
		winner2List.push(address(winners[1]));
		winner3List.push(address(winners[2]));
		emit SetWinner(address(winners[0]), address(winners[1]), address(winners[2]));
	}

	/**
	 * @notice get winner list
	 * @param _count winner count list
	 */
	function getWinnerList(uint8 _count) external view returns (address) {
		if (_count == 1) {
			if (winner1List.length >= 1) {
				uint last1Index = winner1List.length - 1;
				return winner1List[last1Index];
			} else {
				return address(0);
			}
		} else if (_count == 2) {
			if (winner2List.length >= 1) {
				uint last2Index = winner2List.length - 1;
				return winner2List[last2Index];
			} else {
				return address(0);
			}
		} else {
			if (winner3List.length >= 1) {
				uint last3Index = winner3List.length - 1;
				return winner3List[last3Index];
			} else {
				return address(0);
			}
		}
	}
}
