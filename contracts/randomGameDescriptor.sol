// SPDX-License-Identifier: MIT

pragma solidity ^0.8.11;

contract RandomGameDescriptor {
	struct PlayerStruct {
		address playerAddress;
		bool winner;
	}

	uint256 public tokenStart = 0;
	mapping(uint256 => PlayerStruct) public playerList;

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
	function setWinner(uint256 _lastTokenId) external view returns (address) {
		// TODO: winner logic
		return playerList[_lastTokenId].playerAddress;
	}
}
