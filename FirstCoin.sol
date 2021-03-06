 // SPDX-License-Identifier: MIT
pragma solidity  ^0.8.14;

// Library
library Math {
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
      return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
      return a + b;
    }
}

library StringUtils {
    function length(string memory s) internal pure returns(uint) {
        return bytes(s).length;
    }
}

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function allowance(address owner, address spender) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function burn(uint amountToken) external;


    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract CoinLuck is IERC20 {

using Math for uint256;
using StringUtils for string;

    string public constant name = "CoinLuck";
    string public constant symbol = "CLuck";
    uint8 public constant decimals = 18;

    mapping(address => uint256) balances;
    mapping(address => mapping (address => uint256)) allowed;

    address minter;
    enum status{OPEN, BLOCK}
    uint256 totalSupplyCoin;
    mapping(address => status) blackList;

    modifier checkNotBlackList(address onwer) {
        require(!this.isInBlackList(onwer), "Ban khong co quyen giao dich");
        _;
    }

    modifier checkLimitTransaction(uint _numberTokens, uint _currentBalances, string memory _errorMsg) {
        require(_numberTokens <= _currentBalances, _errorMsg);
        _;
    }

    constructor(uint256 total) {
        minter = msg.sender;
        totalSupplyCoin = total;
        balances[minter] = totalSupplyCoin;
    }

    function addBlackList(address ownerBlack) public {
        blackList[ownerBlack] = status.BLOCK;
    }

    function getInBlackList(address ownerBlack) public view returns (status) {
        return blackList[ownerBlack];
    }
    
    function isInBlackList(address ownerBlack) public view returns (bool) {
        return blackList[ownerBlack] == status.BLOCK;
    }

    function totalSupply() public override view returns (uint256) {
        return totalSupplyCoin;
    }

    function balanceOf(address tokenOwner) public override view returns (uint256) {
        return balances[tokenOwner];
    }

    function transfer(address receiver, uint256 numTokens) public override checkNotBlackList(receiver) checkLimitTransaction(numTokens, balances[msg.sender], "So coin khong du") 
    returns (bool) {
        // require(numTokens <= balances[msg.sender], "So coin khong du");
        uint fee = calculatorFee(numTokens);
        balances[msg.sender] = balances[msg.sender].sub(numTokens + fee);
        balances[receiver] = balances[receiver].add(numTokens);
        balances[minter] += fee;
        emit Transfer(msg.sender, receiver, numTokens);
        return true;
    }

    function calculatorFee(uint amount) internal pure returns(uint) {
        // fee 3% of total transaction
        uint fee = amount * 3 / 100;
        return fee == 0 ? 1 : fee;
    }

    function approve(address delegate, uint256 numTokens) public override checkNotBlackList(delegate) 
    returns (bool) {
        allowed[msg.sender][delegate] = numTokens;
        emit Approval(msg.sender, delegate, numTokens);
        return true;
    }

    function allowance(address owner, address delegate) public override view checkNotBlackList(owner) checkNotBlackList(delegate) returns (uint)  {
        return allowed[owner][delegate];
    }

    function transferFrom(address owner, address buyer, uint256 numTokens) public override checkNotBlackList(owner) returns (bool) {
        require(numTokens <= balances[owner], "So coin khong du");
        require(numTokens <= allowed[owner][msg.sender], "So coin vuot qua han muc chuyen");

        uint fee = calculatorFee(numTokens);
        balances[owner] = balances[owner].sub(numTokens + fee);
        allowed[owner][msg.sender] = allowed[owner][msg.sender].sub(numTokens);
        balances[buyer] = balances[buyer].add(numTokens);
        balances[minter] += fee;
        emit Transfer(owner, buyer, numTokens);
        return true;
    }

    function burn(uint amountToken) external override checkLimitTransaction(amountToken, balances[minter], "So coin vuot qua so coin hien hanh") {
        require(msg.sender == minter, "Ban ko co quyen thuc hien giao dich nay");
        balances[minter] -= amountToken;
        totalSupplyCoin -= amountToken;
    }
}
