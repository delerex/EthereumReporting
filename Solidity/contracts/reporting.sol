pragma solidity ^0.4.24;


import "./ireporting.sol";
import "./owned.sol";
import "./audited.sol";

contract Reporting is Owned, Audited {
    event SetValue(
        uint64 indexed _time,
        uint16 indexed _id,
        int256 _value
    );

    event SetParameter(
        uint16 indexed _id,
        string _name
    );


    mapping (uint64 => bool) public audited;
    uint16[] public available_parameters;
    uint64[] public available_dates;
    uint8 public decimals;
    string public company;
    string public units;
    mapping (uint64 => mapping (uint16 => int256)) public report;
    mapping (uint16 => string) public parameters;


    constructor() public{
        decimals = 2;
        company = "Delerex";
        units = "USD";

    }

    function isDate(uint64 id) public view returns (bool exist)
    {
        uint16 i = 0;
        while( i < available_dates.length){
            if(id == available_dates[i]) {
                break;
            }
            i++;
        }
        if(i == available_dates.length){
            return false;
        }
        return true;
    }

    function getDatesCount() public view returns (uint256 count){
        return available_dates.length;
    }

    function getDate(uint16 index) public view returns (uint64 id){
        return available_dates[index];
    }

    function isParameter(uint16 id) public view returns (bool exist)
    {
        uint16 i = 0;
        while( i < available_parameters.length){
            if(id == available_parameters[i]) {
                break;
            }
            i++;
        }
        if(i == available_parameters.length){
            return false;
        }
        return true;
    }


    function getParametersCount() public view returns (uint256 count){
        return available_parameters.length;
    }

    function getParameterId(uint16 index) public view returns (uint16 id){
        return available_parameters[index];
    }


    function setParameter(uint16 id, string name) public onlyOwner returns (bool success)
    {
        if( isParameter(id) == false ){
            available_parameters.push(id);
        }
        parameters[id] = name;
        emit SetParameter(id, name);
        return true;
    }

    function setValue(uint64 time, uint16 id, int256 value ) public returns (bool success)
    {
        if( isDate(time) == false ){
            available_dates.push(time);
        }
        report[time][id] = value;
        audited[time] = false;
        emit SetValue(time, id, value);
        return true;
    }



    // ------------------------------------------------------------------------
    // Get specifict value at specified time
    // ------------------------------------------------------------------------
    function getValue(uint64 time, uint16 id) public view returns (int256 value)
    {
        return report[time][id];
    }



    function setAuditResult(uint64 time, bool status) public onlyAuditor returns (bool success) {
        require(isDate(time) == true);
        audited[time] = status;
        emit SetAuditResult(time, status);
        return true;
    }

    // ------------------------------------------------------------------------
    // Don't accept ETH
    // ------------------------------------------------------------------------
    function () public payable {
        revert();
    }


}