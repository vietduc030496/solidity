pragma solidity ^0.5.1;

contract ERC20Token {
    string public name;
    mapping(address => uint) public balances;
    uint ownerCount;

    constructor(string memory _name) public {
        name = _name;
    }

    function mint() public {
        balances[msg.sender]++;
    }
}

contract MyContract is ERC20Token{
    string public symbol;

    constructor(string memory _name, string memory _symbol) ERC20Token(_name) public {
        symbol = _symbol;
    }

    function mint() public {
        super.mint();
        ownerCount++;
    }
}
