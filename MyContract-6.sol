pragma solidity ^0.5.1;

import "./Math2.sol";

library Math {
    function divide(uint a, uint b) internal pure returns (uint) {
        require(b > 0);
        uint c = a / b;
        return c;
    }
}

contract MyContract {
    uint public value;
    // using Math2 for uint;

    function calculate(uint _value1, uint _value2) public {
        value = Math.divide(_value1, _value2);
        Math2.divide(_value1, _value2);

        // _value1.divide(_value2);
    }

}
