pragma solidity >=0.7.0 <0.9.0;

contract App {
    function revertOrNot(bool fails) public pure returns(uint256) {
        if (fails) {
            revert("Custom error");
        }
        return 5;
    }
}

contract Caller {
    App public app;

    constructor(App _app) {
        app = _app;
    }

    function call(bool fails) public returns(uint256 res) {
        bool success;
        bytes memory returnedValEncoded;
        bytes memory funcWithParams = abi.encodeWithSelector(app.revertOrNot.selector, fails);
        (success, returnedValEncoded) = address(app).call(funcWithParams);
        if (success) {
            res = abi.decode(returnedValEncoded, (uint256));
        }
         else {
            // a revert scenario (not panic)
            assembly {
                // remove the function selector
                returnedValEncoded := add(returnedValEncoded, 0x04)
            }
            string memory revertReason = abi.decode(returnedValEncoded, (string));
            revert(revertReason);
        }
    }
}