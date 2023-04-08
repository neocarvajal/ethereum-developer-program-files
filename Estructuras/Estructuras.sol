// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Clase {

    struct Alumno {
        string nombre;
        uint cedula;
        address wallet;
        uint balance;
        string id;
    }

    Alumno[] public alumnos;

    mapping (string => Alumno[]) public alumnado;

    address private owner;

    constructor(string memory _nombre, uint _cedula, address _wallet, string memory _id) {

        owner = msg.sender;

        alumnos.push(
            Alumno({
                nombre: _nombre,
                cedula: _cedula,
                wallet: _wallet,
                balance: 0,
                id: _id
            })
        );

        alumnado[_id].push(Alumno({nombre: _nombre, cedula: _cedula, wallet: _wallet, balance:0, id: _id}));

    }

    modifier isAuthor() { // require(condición verdadera, condición en caso de error)
        require(owner == msg.sender, "Debe ser el owner para agregar alumnos");
        _;
    }

    function agregarFondos(address _wallet, uint _monto, uint _index) public payable{
        payable(_wallet).transfer(_monto);
        Alumno memory alumno = alumnos[_index];
        alumno.balance += _wallet.balance;
    }

    function agregarAlumno(string memory _nombre, uint _cedula, address _wallet, string memory _id) public isAuthor(){
        alumnos.push(
            Alumno({
                nombre: _nombre,
                cedula: _cedula,
                wallet: _wallet,
                balance: 0,
                id: _id
            })
        );

        alumnado[_id].push(Alumno({nombre: _nombre, cedula: _cedula, wallet: _wallet, balance:0, id: _id}));

    }

    function verAlumnos() public view returns(string[] memory) {
        // return alumnado;
    }
}
