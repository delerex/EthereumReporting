pragma solidity ^0.4.24;

import "./owned.sol";

// ----------------------------------------------------------------------------
// Audited contract
// ----------------------------------------------------------------------------
contract Audited is Owned{
    address public auditor;

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

}