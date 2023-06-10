pragma solidity >=0.7.0 <0.9.0;

contract Token {
    event Transfer(address indexed to, uint256 value, uint256 param3, uint256 param4);

    function transfer(address to, uint256 value) public {
        uint256 param3;
        uint256 param4;
        bytes calldata allParams = msg.data;
        uint256 len = allParams. length;
        assembly {
            calldatacopy (0x0, sub (len, 64), 32) param3 := mload(0)
            calldatacopy (0x0, sub (len, 32), 32) param4 := mload(0)
        }

        emit Transfer(to, value, param3, param4);
    }
}

contract Caller {
    Token public token;

    constructor(Token _token) {
        token = _token;
    }

    function call(uint256 param3, uint256 param4) public {
        bytes memory funcWithParams = abi.encodeWithSelector(token.transfer.selector, msg.sender, 12345, param3, param4);
        address(token).call(funcWithParams);
    }
}