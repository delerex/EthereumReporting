pragma solidity ^0.4.24;


/**
 * @title Financial Reporting interface
 * @dev 
 */

contract IReporting  {

    function setValue(uint64 time, uint16 id, uint256 value ) public returns (bool success);
    function getValue(uint64 time, uint16 id) public view returns (int256 value);
    function setParameter(uint16 id, string name) public returns (bool success);


}