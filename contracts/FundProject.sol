// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Project {

    struct FundProjectData {
        string id;
        string name;
        string description;
        address payable author;
        string state;
        uint funds;
        uint fundraisingGoal;

    }

    FundProjectData public fundData;

    constructor(string memory _id, string memory _name, string memory _description, uint fundraisingGoal ) {
        fundData = FundProjectData(_id, _name, _description, payable(msg.sender), "open", 0, fundraisingGoal);
    }

    modifier difOwner() {
        require(
            fundData.author != msg.sender,
            "Owner can't fund the project"
        );
        // La función es insertada en donde aparece este símbolo
        _;
    }

    modifier onlyOwnerState() {
        require(
            fundData.author == msg.sender,
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
    
        if(keccak256(abi.encodePacked(fundData.state)) == keccak256(abi.encodePacked("closed"))) {
            string memory msgError = "El proyecto esta cerrado";
            revert projectClosed(msgError, fundData.state);
        }else {
            _donator.transfer(msg.value);
            uint amount = msg.value;
            emit addFunds("Gracias por su aporte", _donator, amount);
            fundData.funds += amount;
        }   
    }

    event changeState(string message, string oldState, string newState);

    function changeProjectState(string memory _newState) public onlyOwnerState {
        string memory oldState = fundData.state;
        fundData.state = _newState;

        emit changeState("El autor ha cambiado el estado", oldState, fundData.state);
    }

}
