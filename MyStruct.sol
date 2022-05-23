pragma solidity ^0.5.1;

contract MyStruct {

    Person[] public people;
    uint public peopletCount;
    mapping(uint => Person) public peopleMap;

    address owner;

    modifier onlyOwner() {
        require(owner == msg.sender);
        _;
    }


    uint openTime = 1653280999;
    modifier onlyWhileOpen() {
        require(block.timestamp >= openTime);
        _;
    }

    constructor() public {
        owner = msg.sender;
    }

    struct Person {
        uint _id;
        string _firstName;
        string _lastName;
    }

    function addPeople(string memory _firstName, string memory _lastName) public onlyWhileOpen {
        incrementCount();
        peopleMap[peopletCount] = Person(peopletCount, _firstName, _lastName);
    }

    function incrementCount() internal{
        peopletCount++;
    }

}
