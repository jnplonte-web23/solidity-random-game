// SPDX-License-Identifier: MIT

pragma solidity ^0.8.16;

import './hedera/HederaTokenService.sol';
import './hedera/HederaResponseCodes.sol';
import 'hardhat/console.sol';

contract RandomGameDescriptor {
	struct PlayerStruct {
		address playerAddress;
		address referalAddress;
		bool active;
	}

	mapping(uint256 => PlayerStruct) public playerList;

	function getRandomNumber(uint8 _count, uint256 _start, uint256 _end) public view returns (uint256) {
		uint256 random = uint256(keccak256(abi.encodePacked(block.timestamp, _count)));
		return (random % (_end + 1)) + _start;
	}

	/**
	 * @notice clear player list
	 * @param _lastTokenId last token id
	 */
	function clearPlayerData(uint256 _lastTokenId) external {
		uint256 i = 0;
		for (i; i < _lastTokenId; i++) {
			if (playerList[i].active) {
				delete playerList[i];
			}
		}
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
	 * @param _referalAddress referal address
	 */
	function setPlayerData(uint256 _tokenId, address _playerAddress, address _referalAddress) external {
		PlayerStruct storage playerStorage = playerList[_tokenId];
		playerStorage.playerAddress = _playerAddress;
		playerStorage.referalAddress = _referalAddress;
		playerStorage.active = true;
	}

	/**
	 * @notice set winner
	 * @param _lastTokenId last token id
	 */
	function setWinner(
		uint256 _lastTokenId,
		uint8 _winnerCount
	) external view returns (address[3] memory, address[3] memory) {
		uint256 winner1 = getRandomNumber(11, 0, _lastTokenId);
		PlayerStruct memory finalWinner1 = playerList[winner1];

		uint256 winner2;
		PlayerStruct memory finalWinner2;
		if (_winnerCount >= 2) {
			winner2 = getRandomNumber(22, 0, _lastTokenId);
			// NOTE: make sure winner 2 is not winner1
			uint8 w2 = 1;
			while (winner2 == winner1) {
				winner2 = getRandomNumber(22 + w2, 0, _lastTokenId);
				w2++;
			}

			finalWinner2 = playerList[winner2];
		}

		uint256 winner3;
		PlayerStruct memory finalWinner3;
		if (_winnerCount >= 3) {
			winner3 = getRandomNumber(33, 0, _lastTokenId);
			// NOTE: make sure winner 3 is not winner1 and winner2
			uint8 w3 = 1;
			while (winner3 == winner1 || winner3 == winner2) {
				winner3 = getRandomNumber(33 + w3, 0, _lastTokenId);
				w3++;
			}

			finalWinner3 = playerList[winner3];
		}

		return (
			[address(finalWinner1.playerAddress), address(finalWinner2.playerAddress), address(finalWinner3.playerAddress)],
			[address(finalWinner1.referalAddress), address(finalWinner2.referalAddress), address(finalWinner3.referalAddress)]
		);
	}
}
