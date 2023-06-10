pragma solidity >=0.7.0 <0.9.0;

contract App {
    function revertOrNot(bool fails) public pure returns(uint256) {
        if (fails) {
            revert("Custom error");
        }
        return 5;
    }
}

library Strings {
    /**
     * @dev Converts a `uint256` to its ASCII `string` decimal representation
     * @notice Inspired by OraclizeAPI's implementation - MIT licence
     * https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
     * @param _num Input number
     * @return Number represented as a string
     */
    function toString(uint256 _num) public pure returns (string memory) {
        if (_num == 0) {
            return '0';
        }
        uint256 _temp = _num;
        uint256 _digits;
        while (_temp != 0) {
            _digits++;
            _temp /= 10;
        }
        bytes memory _buffer = new bytes(_digits);
        while (_num != 0) {
            _digits -= 1;
            _buffer[_digits] = bytes1(uint8(48 + uint256(_num % 10)));
            _num /= 10;
        }
        return string(_buffer);
    }
}

contract TryCatch {
    using Strings for uint256;
    using Strings for bytes;
    App public app;

    constructor(App _app) {
        app = _app;
    }

    function mayFail(bool fails) public view returns (uint256 res) {
        try app.revertOrNot(fails) returns (uint256 _res) {
            res = _res;
        } catch Error (string memory reason) {
            revert(reason);
        } catch Panic (uint256 errorCode) {
            revert(errorCode.toString());
        } catch (bytes memory lowLevelData) {
            revert(string(lowLevelData));
        }
    }
}