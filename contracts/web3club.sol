// SPDX-License-Identifier: MIT

pragma solidity 0.8.14;

contract Web3Club {
    uint256 public clubCount;
    uint256 public postCount;

    struct Club {
        string clubName;
        string clubDescription;
        string clubProfilePic;
        string clubCategory;
        address clubAdmin;
    }

    struct Post {
        string postContent;
        uint256 postClubId;
        address postedBy;
    }

    mapping(uint256 => Club) public clubIdToClub;
    mapping(uint256 => Post) public postIdToPost;

    uint256 public ownerCount;
    mapping(address => uint256) public ownerToOwnerId;
    uint256 public blockedOwnerCount;
    mapping(address => uint256) public blockedOwnerToOwnerId;

    constructor() {
        blockedOwnerCount = 0;
        ownerCount = 1;
        ownerToOwnerId[msg.sender] = ownerCount;
        clubCount = 0;
        postCount = 0;
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

    function addClub(
        string memory _clubName,
        string memory _clubDescription,
        string memory _clubProfilePic,
        string memory _clubcategory,
        address _admin
    ) public onlyOwner {
        clubCount = clubCount + 1;
        clubIdToClub[clubCount].clubName = _clubName;
        clubIdToClub[clubCount].clubDescription = _clubDescription;
        clubIdToClub[clubCount].clubProfilePic = _clubProfilePic;
        clubIdToClub[clubCount].clubCategory = _clubcategory;
        clubIdToClub[clubCount].clubAdmin = _admin;
    }

    function addPost(
        string memory _postContent,
        uint256 _clubId,
        address _postedBy
    ) public onlyOwner {
        postCount = postCount + 1;
        postIdToPost[postCount].postContent = _postContent;
        postIdToPost[postCount].postClubId = _clubId;
        postIdToPost[postCount].postedBy = _postedBy;
    }
}
