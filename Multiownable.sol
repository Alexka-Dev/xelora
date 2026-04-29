pragma solidity 0.4.23;

import "../zeppelin/contracts/ownership/Ownable.sol";

/**
 * @title Multiownable
 * @dev Extension of Ownable that allows multiple addresses to be authorized
 * to perform owner-only actions.
 */
contract Multiownable is Ownable {
    mapping(address => bool) public isOwner;
    address[] public owners;

    event OwnerAdded(address indexed addedOwner);
    event OwnerRemoved(address indexed removedOwner);

    modifier onlyMultiowner() {
        require(
            isOwner[msg.sender] || msg.sender == owner,
            "Sender is not an authorized owner"
        );
        _;
    }

    constructor() public {
        isOwner[msg.sender] = true;
        owners.push(msg.sender);
    }

    function addOwner(address _newOwner) external onlyOwner {
        require(_newOwner != address(0), "Invalid address");
        require(!isOwner[_newOwner], "Address is already an owner");

        isOwner[_newOwner] = true;
        owners.push(_newOwner);
        emit OwnerAdded(_newOwner);
    }

    function removeOwner(address _toRemove) external onlyOwner {
        require(isOwner[_toRemove], "Address is not an owner");
        require(_toRemove != owner, "Cannot remove the primary contract owner");

        isOwner[_toRemove] = false;
        emit OwnerRemoved(_toRemove);
    }
}
