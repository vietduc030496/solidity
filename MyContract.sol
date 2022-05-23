pragma solidity ^0.5.1;

contract MyContract {
    string public stringValue = "myValue";
    bool public myBool = true;
    int public myInt = 1;
    uint public myUint = 1;
    enum State {Waiting, Ready, Active}

    State public state;

    constructor () public {
        state = State.Waiting;
    }

    function activate() public {
        state = State.Active;
    }

    function isActivate() public view returns(bool){
        return state == State.Active;
    }
    
}
