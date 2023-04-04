// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Project {

    address private owner;
    string public state = "open";

    constructor() {
        owner = msg.sender;
    }

    modifier difOwner() {
        require(
            msg.sender != owner,
            "Owner can't fund the project"
        );
        // La función es insertada en donde aparece este símbolo
        _;
    }

    modifier onlyOwnerState() {
        require(
            msg.sender == owner,
            "Only owner can change the project name"
        );
        // La función es insertada en donde aparece este símbolo
        _;
    }

    function fundProject(address payable receiver) public payable difOwner  {
        receiver.transfer(msg.value);
    }

    function changeProjectState(string memory _newState) public onlyOwnerState {
        state = _newState;
    }

}
