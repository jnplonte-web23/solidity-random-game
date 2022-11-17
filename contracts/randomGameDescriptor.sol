// SPDX-License-Identifier: MIT

pragma solidity ^0.8.16;

import './hedera/HederaTokenService.sol';
import './hedera/HederaResponseCodes.sol';
import 'hardhat/console.sol';

import './interfaces/IHederaTokenService.sol';

contract RandomGameDescriptor is HederaTokenService {
	event SetWinner(address indexed finalWinner1, address indexed finalWinner2, address indexed finalWinner3);

	struct PlayerStruct {
		address playerAddress;
		address referalAddress;
	}

	uint8 private referalFee = 10;
	uint8 private winner1Fee = 50;
	uint8 private winner2Fee = 30;
	uint8 private winner3Fee = 20;

	address[] public winner1List;
	address[] public winner2List;
	address[] public winner3List;

	uint256 private startOnTokenId = 0;
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
	 * @param _referalAddress referal address
	 */
	function setPlayerData(uint256 _tokenId, address _playerAddress, address _referalAddress) external {
		PlayerStruct storage playerStorage = playerList[_tokenId];
		playerStorage.playerAddress = _playerAddress;
		playerStorage.referalAddress = _referalAddress;
	}

	/**
	 * @notice get token start
	 */
	function getTokenStart() external view returns (uint256) {
		return startOnTokenId;
	}

	/**
	 * @notice get player data
	 * @param _tokenId token id
	 */
	function setTokenStart(uint256 _tokenId) external {
		startOnTokenId = _tokenId;
	}

	/**
	 * @notice get winner list
	 * @param _count winner count list
	 */
	function getWinnerList(uint8 _count) external view returns (address[] memory) {
		if (_count == 1) {
			return winner1List;
		} else if (_count == 2) {
			return winner2List;
		} else {
			return winner3List;
		}
	}

	/**
	 * @notice set winner
	 * @param _lastTokenId last token id
	 */
	function setWinner(uint256 _lastTokenId) external {
		uint256 winner1 = getRandomNumber(1, startOnTokenId, _lastTokenId);

		uint256 winner2 = getRandomNumber(2, startOnTokenId, _lastTokenId);
		uint8 w2 = 1;
		while (winner2 == winner1) {
			winner2 = getRandomNumber(2 + w2, startOnTokenId, _lastTokenId);
			w2++;
		}

		uint256 winner3 = getRandomNumber(3, startOnTokenId, _lastTokenId);
		uint8 w3 = 1;
		while (winner3 == winner1 || winner3 == winner2) {
			winner3 = getRandomNumber(3 + w3, startOnTokenId, _lastTokenId);
			w3++;
		}

		PlayerStruct memory finalWinner1 = playerList[winner1];
		PlayerStruct memory finalWinner2 = playerList[winner2];
		PlayerStruct memory finalWinner3 = playerList[winner3];

		IHederaTokenService.AccountAmount[] memory winners = new IHederaTokenService.AccountAmount[](3);
		winners[1] = IHederaTokenService.AccountAmount(address(finalWinner1.playerAddress), 10, true);
		winners[2] = IHederaTokenService.AccountAmount(address(finalWinner2.playerAddress), 10, true);
		winners[3] = IHederaTokenService.AccountAmount(address(finalWinner3.playerAddress), 10, true);

		IHederaTokenService.TransferList memory finalWinner = IHederaTokenService.TransferList(winners);
		IHederaTokenService.TokenTransferList[] memory finalWinnerList;

		int responseCode = HederaTokenService.cryptoTransfer(finalWinner, finalWinnerList);
		if (responseCode != HederaResponseCodes.SUCCESS) {
			revert('error');
		}

		winner1List.push(finalWinner1.playerAddress);
		winner2List.push(finalWinner2.playerAddress);
		winner3List.push(finalWinner3.playerAddress);
		emit SetWinner(finalWinner1.playerAddress, finalWinner2.playerAddress, finalWinner3.playerAddress);
	}
}
