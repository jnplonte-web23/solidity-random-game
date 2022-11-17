// SPDX-License-Identifier: MIT

/// @title Interface for IRandomGameDescriptor

pragma solidity ^0.8.16;

interface IRandomGameDescriptor {
	function getPlayerData(uint256 _tokenId) external view returns (address);

	function setPlayerData(uint256 _tokenId, address _playerAddress, address _referalAddress) external;

	function getTokenStart() external view returns (uint256);

	function setTokenStart(uint256 _tokenId) external;

	function getWinnerList(uint8 _count) external view returns (address[] memory);

	function setWinner(uint256 _lastTokenId) external;
}
