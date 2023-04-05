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

    error projectClosed(string message, string _state);
    event addFunds(string message, address donator, uint amount );

    function fundProject(address payable _donator) public payable difOwner  {
        require(
            msg.value > 0,
            "Debe ingresar un monto mayor a 0" 
        );
    
        if(keccak256(abi.encodePacked(state)) == keccak256(abi.encodePacked("closed"))) {
            string memory msgError = "El proyecto esta cerrado";
            revert projectClosed(msgError, state);
        }else {
            _donator.transfer(msg.value);
            uint amount = msg.value;
            emit addFunds("Gracias por su aporte", _donator, amount);
        }   
    }

    event changeState(string message, string oldState, string newState);

    function changeProjectState(string memory _newState) public onlyOwnerState {
        string memory oldState = state;
        state = _newState;

        emit changeState("El autor ha cambiado el estado", oldState, state);
    }

}
