// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0;

contract SimpleStorage {
    uint256 public favoriteNumber = 5;
    bool favoriteBool = false;
    string favoriteString = 'string';
    address favoriteAddress = 0xC959Cafd6b75131475191CABBE102f5b873e2b02;
    bytes3 favoriteBytes = 'cat';

    struct People {
        uint256 favoriteNumber;
        string name;
    }

    People[] public people;
    mapping(string  => uint256) public nameToFavoriteNumber;

    People public person = People({ favoriteNumber: 2, name: 'Ricardo' });

    function store(uint256 _favoriteNumber) public {
        favoriteNumber = _favoriteNumber;
    }

    function retrieve() public view returns(uint256) {
        return favoriteNumber;
    }

    function addPerson(string memory _name, uint256 _favoriteNumber) public {
        people.push(People(_favoriteNumber, _name));
        nameToFavoriteNumber[_name] = _favoriteNumber;
    }
}