pragma solidity ^0.4.24;

import "./owned.sol";

// ----------------------------------------------------------------------------
// Audited contract
// ----------------------------------------------------------------------------
contract Audited is Owned{
    address public auditor;
    mapping (uint64 => bool) public confirmed;

    event SetAuditor(address indexed _to);
    event SetAuditResult(uint64 indexed _time, bool _status);

    constructor() public {
        auditor = address(0);
    }

    modifier onlyAuditor {
        require(msg.sender == auditor);
        _;
    }

    function setAuditor(address _newAuditor) public onlyOwner {
        auditor = _newAuditor;
    }

    function setAuditResult(uint64 time, bool status) public onlyAuditor returns (bool success) {
        confirmed[time] = status;
        emit SetAuditResult(time, status);
        return true;
    }

}