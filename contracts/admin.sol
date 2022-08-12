// SPDX-License-Identifier: MIT

import "./login.sol";
import "./web3club.sol";
pragma solidity 0.8.14;

contract Admin {
    BitUser bituser;
    Web3Club web3Club;

    uint256 public ownerCount;
    mapping(address => uint256) public ownerToOwnerId;
    uint256 public blockedOwnerCount;
    mapping(address => uint256) public blockedOwnerToOwnerId;

    constructor(address _bitUser, address _web3Club) {
        blockedOwnerCount = 0;
        ownerCount = 1;
        ownerToOwnerId[msg.sender] = ownerCount;
        bituser = BitUser(_bitUser);
        web3Club = Web3Club(_web3Club);
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
        bituser.addUser(_userAddress, _userName, _userDescription, _profilepic);
    }

    function addClub(
        string memory _clubName,
        string memory _clubDescription,
        string memory _clubProfilePic,
        string memory _clubcategory,
        address _admin
    ) public onlyOwner {
        web3Club.addClub(
            _clubName,
            _clubDescription,
            _clubProfilePic,
            _clubcategory,
            _admin
        );
    }

    function addPost(
        string memory _postContent,
        uint256 _clubId,
        address _postedBy
    ) public onlyOwner {
        web3Club.addPost(_postContent, _clubId, _postedBy);
    }
}
