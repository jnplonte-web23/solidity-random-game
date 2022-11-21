// SPDX-License-Identifier: MIT

/// @title Interface for IRandomGameDescriptor

pragma solidity ^0.8.16;

interface IRandomGameDescriptor {
	function clearPlayerData(uint256 _lastTokenId) external;

	function getPlayerData(uint256 _tokenId) external view returns (address);

	function setPlayerData(uint256 _tokenId, address _playerAddress, address _referalAddress) external;

	function getWinnerList(uint8 _count) external view returns (address[] memory);

	function setWinner(uint256 _lastTokenId) external;
}
