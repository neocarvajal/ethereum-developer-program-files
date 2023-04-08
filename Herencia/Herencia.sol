// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "./Interface.sol";
import "./Modifier.sol";

contract Herencia is Suma, Modifier { // Contrato hereda de la interface Suma y del contrato Modifier

    constructor(string memory _nombreNuevo) Modifier(_nombreNuevo) {
        
    }

    function sumar(uint numero1, uint numero2) public view override isAuthor() returns (uint) {
        return numero1 + numero2;
    }

}
