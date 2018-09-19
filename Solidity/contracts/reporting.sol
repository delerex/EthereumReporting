pragma solidity ^0.4.24;


import "./ireporting.sol";
import "./owned.sol";
import "./audited.sol";

contract Reporting is IReporting, Owned, Audited {


    mapping (uint16 => string) public parameters;
    mapping (uint64 => mapping (uint16 => int256)) public values;
    mapping (uint64 => bool) public audited;
    uint16[] public available_parameters;
    uint64[] public available_dates;

    uint8 public decimals;
    string public company;
    string public units;


    constructor() public{
        decimals = 2; // set decimal counter
        company = "Delerex Pte. Ltd"; // set company name
        units = "USD"; // set basic unit
    }

    // ------------------------------------------------------------------------
    // Checks if the date is already used in the contract
    // ------------------------------------------------------------------------
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

    // ------------------------------------------------------------------------
    // get report dates count
    // ------------------------------------------------------------------------
    function getDatesCount() public view returns (uint256 count){
        return available_dates.length;
    }

    // ------------------------------------------------------------------------
    // get report date by index
    // ------------------------------------------------------------------------
    function getDate(uint16 index) public view returns (uint64 date){
        return available_dates[index];
    }

    // ------------------------------------------------------------------------
    // is parameter id already used in contract
    // ------------------------------------------------------------------------
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

    // ------------------------------------------------------------------------
    // Get parameters count
    // ------------------------------------------------------------------------
    function getParametersCount() public view returns (uint256 count){
        return available_parameters.length;
    }

    // ------------------------------------------------------------------------
    // Get parameter id at specified index
    // ------------------------------------------------------------------------
    function getParameterId(uint16 index) public view returns (uint16 id){
        return available_parameters[index];
    }

    // ------------------------------------------------------------------------
    // Get parameter name for specified parameter id
    // ------------------------------------------------------------------------
    function getParameter(uint16 parameter_id) public view returns (string parameter){
        return parameters[parameter_id];
    }

    // ------------------------------------------------------------------------
    // Assign parameter name to specified parameter id
    // ------------------------------------------------------------------------

    function setParameter(uint16 parameter_id, string name) public onlyOwner returns (bool success)
    {
        if( isParameter(parameter_id) == false ){
            available_parameters.push(parameter_id);
        }
        parameters[parameter_id] = name;
        emit SetParameter(parameter_id, name);
        return true;
    }

    // ------------------------------------------------------------------------
    // Set parameters value at specified time
    // ------------------------------------------------------------------------

    function setValue(uint64 time, uint16 parameter_id, int256 value ) onlyOwner public returns (bool success)
    {
        if( isDate(time) == false ){
            available_dates.push(time);
        }
        values[time][parameter_id] = value;
        audited[time] = false;
        emit SetValue(time, parameter_id, value);
        return true;
    }



    // ------------------------------------------------------------------------
    // Get parameters value at specified time
    // ------------------------------------------------------------------------
    function getValue(uint64 time, uint16 parameter_id) public view returns (int256 value)
    {
        return values[time][parameter_id];
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