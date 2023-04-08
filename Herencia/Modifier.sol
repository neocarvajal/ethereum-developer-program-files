// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Modifier {
    address private owner;
    string private nombreOwner;

    constructor(string memory _nombre) {
        owner = msg.sender;
        nombreOwner = _nombre;
    }

    modifier isAuthor() { // require(condición verdadera, condición en caso de error)
        require(owner == msg.sender, "Debe ser el owner para agregar alumnos");
        _;
    }
    
}
