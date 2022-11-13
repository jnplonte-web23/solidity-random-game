// SPDX-License-Identifier: MIT

pragma solidity ^0.8.16;

import 'hardhat/console.sol';

contract RandomGameDescriptor {
	struct PlayerStruct {
		address playerAddress;
		bool winner;
	}

	uint256 public tokenStart = 0;
	mapping(uint256 => PlayerStruct) public playerList;

	function getRandomNumber(uint8 _count, uint256 _start, uint256 _end) public view returns (uint256) {
		uint256 random = uint256(keccak256(abi.encodePacked(block.timestamp, _count)));
		return (random % _end) + _start;
	}

	/**
	 * @notice get player data
	 * @param _tokenId token id
	 */
	function getPlayerData(uint256 _tokenId) external view returns (address) {
		return playerList[_tokenId].playerAddress;
	}

	/**
	 * @notice set the setPlayerData
	 * @param _tokenId token id
	 * @param _playerAddress player address
	 */
	function setPlayerData(uint256 _tokenId, address _playerAddress) external {
		PlayerStruct storage playerStorage = playerList[_tokenId];
		playerStorage.playerAddress = _playerAddress;
		playerStorage.winner = false;
	}

	/**
	 * @notice get token start
	 */
	function getTokenStart() external view returns (uint256) {
		return tokenStart;
	}

	/**
	 * @notice get player data
	 * @param _tokenId token id
	 */
	function setTokenStart(uint256 _tokenId) external {
		tokenStart = _tokenId;
	}

	/**
	 * @notice set winner
	 */
	function setWinner(uint256 _lastTokenId) external view returns (address, address, address) {
		uint256 winner1 = getRandomNumber(1, tokenStart, _lastTokenId);

		uint256 winner2 = getRandomNumber(2, tokenStart, _lastTokenId);
		uint8 w2 = 1;
		while (winner2 == winner1) {
			winner2 = getRandomNumber(2 + w2, tokenStart, _lastTokenId);
			w2++;
		}

		uint256 winner3 = getRandomNumber(3, tokenStart, _lastTokenId);
		uint8 w3 = 1;
		while (winner3 == winner1 || winner3 == winner2) {
			winner3 = getRandomNumber(3 + w3, tokenStart, _lastTokenId);
			w3++;
		}

		return (playerList[winner1].playerAddress, playerList[winner2].playerAddress, playerList[winner3].playerAddress);
	}
}
