// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Project {

    enum ProjectState { open, closed }

    struct FundProjectData {
        string id;
        string name;
        string description;
        address payable author;
        ProjectState state;
        uint funds;
        uint fundraisingGoal;

    }

    FundProjectData public fundData;

    constructor(string memory _id, string memory _name, string memory _description, uint fundraisingGoal ) {
        fundData = FundProjectData(_id, _name, _description, payable(msg.sender), ProjectState.open, 0, fundraisingGoal);
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

    error projectClosed(string message, ProjectState _state);
    event addFunds(string message, address donator, uint amount );

    function fundProject(address payable _donator) public payable difOwner  {
        require(
            msg.value > 0,
            "Debe ingresar un monto mayor a 0" 
        );
    
        if(fundData.state == ProjectState.closed) {
            revert projectClosed("El proyecto esta cerrado", fundData.state);
        }else {
            _donator.transfer(msg.value);
            uint amount = msg.value;
            emit addFunds("Gracias por su aporte", _donator, amount);
            fundData.funds += amount;
        }   
    }

    event changeState(string message, ProjectState oldState, ProjectState newState);

    function changeProjectState(ProjectState _newState) public onlyOwnerState {
        ProjectState oldState = fundData.state;
        fundData.state = _newState;

        emit changeState("El autor ha cambiado el estado", oldState, fundData.state);
    }

}
