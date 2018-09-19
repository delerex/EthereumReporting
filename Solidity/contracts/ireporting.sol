pragma solidity ^0.4.24;


/**
 * @title Financial Reporting interface
 * @dev 
 */



contract IReporting  {

    
    /// @notice if there are no values on specified time, time is added to available dates
    /// @dev sets value of specified parameter id on a specified date
    /// @param time UTC timestamp
    /// @param parameter_id parameter id 
    /// @param value integer representation of the value
    /// @return True if successfull
    function setValue(uint64 time, uint16 parameter_id, int256 value ) public returns (bool success);

    /// @notice if there are no values on specified time, zero is returned
    /// @dev gets value of specified parameter id on a specified date
    /// @param time UTC timestamp
    /// @param parameter_id parameter id 
    /// @return integer representation of the value 
    function getValue(uint64 time, uint16 parameter_id) public view returns (int256 value);

    /// @dev assigns name to specified parameter id
    /// @param parameter_id parameter id 
    /// @param name string representation of the parameter
    /// @return True when successful
    function setParameter(uint16 parameter_id, string name) public returns (bool success);

    /// @dev gets parameters count
    /// @return quantity of parameters used in this contract
    function getParametersCount() public view returns (uint256 count);

    /// @dev gets parameters id by index
    /// @return quantity of parameters used in this contract
    function getParameterId(uint16 index) public view returns (uint16 parameter_id);

    /// @dev gets date by index
    /// @return UTC timestamp of the specified date record
    function getDate(uint16 index) public view returns (uint64 parameter_id);

    /// @dev sets audit result
    /// @param time UTC timestamp
    /// @param status if all parameters on a specified dates are confirmed
    /// @return True if successful
    function setAuditResult(uint64 time, bool status) public returns (bool success);

    
    /**
    * @dev This emits when value of parameter is updated
    */ 
    event SetValue(
        uint64 indexed _time,
        uint16 indexed _parameter_id,
        int256 _value
    );

    /**
    * @dev This emits when string data is assigned to specified parameter id
    */ 
    event SetParameter(
        uint16 indexed _parameter_id,
        string _name
    ); 

}    
