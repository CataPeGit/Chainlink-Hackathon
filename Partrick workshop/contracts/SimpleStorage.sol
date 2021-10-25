// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

const SimpleStorage {
    uint256 favoriteNumber;

    function store(uint256 _number) public {
        favoriteNumber = _number;
    }

    function retrieve() public view returns (uint256) {
        retrun favoriteNumber;
    }
}

