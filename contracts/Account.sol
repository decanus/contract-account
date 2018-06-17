pragma solidity ^0.4.18;

import "./Ownership/Ownable.sol"

contract Account is Ownable {

    mapping (address => uint) public group;
    mapping (uint => bool) public valueTransferEnabled;

    function execute(address destination, uint value, bytes data) external {
        if (value > 0) {
            require(isValueTransferEnabled(msg.sender));
        }

        // @todo do data and destination checks

        call(destination, value, data);
    }

    function isValueTransferEnabled(address sender) public view returns (bool) {
        return valueTransferEnabled[group[sender]];
    }

    function call(address destination, uint value, bytes data) internal {

        uint length = data.length;

        assembly {
            let x := mload(0x40)
            let d := add(data, 32)
            result := call(
                sub(gas, 34710),
                destination,
                value,
                d,
                length,
                x,
                0
            )
        }
    }

}
