pragma solidity ^0.4.18;

import "./Ownership/Ownable.sol";

contract Account is Ownable {

    mapping (address => uint) public group;
    mapping (uint => bool) public valueTransferEnabled;

    function execute(address destination, uint value, bytes data) external {
        require(group[msg.sender] > 0);

        if (value > 0) {
            require(isValueTransferEnabled(msg.sender));
        }

        // @todo do data and destination checks

        executeCall(destination, value, data);
    }

    function setGroup(address addr, uint _group) external onlyOwner {
        group[addr] = _group;
    }

    function setValueTransferForGroup(uint _group, bool enabled) external onlyOwner {
        valueTransferEnabled[_group] = enabled;
    }

    function isValueTransferEnabled(address sender) public view returns (bool) {
        return valueTransferEnabled[group[sender]];
    }

    function executeCall(address destination, uint value, bytes data) internal returns (bool) {

        uint length = data.length;
        bool result;

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

        return result;
    }

}
