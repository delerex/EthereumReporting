pragma solidity ^0.4.24;


/**
 * @title Financial Reporting interface
 * @dev 
 */

contract IReporting  {

    function setValue(uint64 time, uint16 id, int256 value ) public returns (bool success);
    function getValue(uint64 time, uint16 id) public view returns (int256 value);
    function setParameter(uint16 id, string name) public returns (bool success);
    function getParametersCount() public view returns (uint256 count);
    function getParameterId(uint16 index) public view returns (uint16 id);
    function getDate(uint16 index) public view returns (uint64 id);
    function setAuditResult(uint64 time, bool status) public returns (bool success);
    
    event SetValue(
        uint64 indexed _time,
        uint16 indexed _parameter_id,
        int256 _value
    );

    event SetParameter(
        uint16 indexed _parameter_id,
        string _name
    ); 

}