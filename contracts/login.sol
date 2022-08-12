// SPDX-License-Identifier: MIT

pragma solidity 0.8.14;

contract BitUser {
    struct User {
        string username;
        string userDescription;
        string userprofilepic;
    }

    mapping(address => User) public addressToUser;

    uint256 public ownerCount;
    mapping(address => uint256) public ownerToOwnerId;
    uint256 public blockedOwnerCount;
    mapping(address => uint256) public blockedOwnerToOwnerId;

    constructor() {
        blockedOwnerCount = 0;
        ownerCount = 1;
        ownerToOwnerId[msg.sender] = ownerCount;
    }

    modifier onlyOwner() {
        require(
            ownerToOwnerId[msg.sender] > 0,
            "Only owner can call this function."
        );
        require(
            blockedOwnerToOwnerId[msg.sender] == 0,
            "You have been blocked."
        );
        _;
    }

    function setOwner(address _newOwner) public onlyOwner {
        require(ownerToOwnerId[_newOwner] == 0, "Owner already added.");
        ownerCount = ownerCount + 1;
        ownerToOwnerId[_newOwner] = ownerCount;
    }

    function blockOwner(address _owner) external onlyOwner {
        require(msg.sender != _owner, "You cannot block yourself");
        blockedOwnerCount = blockedOwnerCount + 1;
        blockedOwnerToOwnerId[_owner] = blockedOwnerCount;
    }

    function addUser(
        address _userAddress,
        string memory _userName,
        string memory _userDescription,
        string memory _profilepic
    ) public onlyOwner {
        addressToUser[_userAddress].username = _userName;
        addressToUser[_userAddress].userDescription = _userDescription;
        addressToUser[_userAddress].userprofilepic = _profilepic;
    }
}
