// SPDX-License-Identifier: MIT

/// @title Interface for IRandomGameDescriptor

pragma solidity ^0.8.16;

interface IRandomGameDescriptor {
	function clearPlayerData(uint256 _lastTokenId) external;

	function getPlayerData(uint256 _tokenId) external view returns (address);

	function setPlayerData(uint256 _tokenId, address _playerAddress, address _referalAddress) external;

	function setWinner(
		uint256 _lastTokenId,
		uint8 _winnerCount
	) external view returns (address[3] memory, address[3] memory);
}
