// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract InsurancePolicy {
    struct Policy {
        address policyholder;
        uint256 premium;
        uint256 coverage;
        uint256 expirationDate;
        bool active;
    }

    mapping(address => Policy) public policies;

    event PolicyCreated(address indexed policyholder, uint256 premium, uint256 coverage, uint256 expirationDate);
    event PolicyActivated(address indexed policyholder);
    event PolicyDeactivated(address indexed policyholder);

    modifier onlyPolicyholder() {
        require(policies[msg.sender].policyholder == msg.sender, "Not the policyholder");
        _;
    }

    function createPolicy(uint256 _premium, uint256 _coverage, uint256 _duration) external {
        require(policies[msg.sender].policyholder == address(0), "Policy already exists for this policyholder");

        Policy memory newPolicy = Policy({
            policyholder: msg.sender,
            premium: _premium,
            coverage: _coverage,
            expirationDate: block.timestamp + _duration,
            active: false
        });

        policies[msg.sender] = newPolicy;
        
        emit PolicyCreated(msg.sender, _premium, _coverage, block.timestamp + _duration);
    }

    function activatePolicy() external onlyPolicyholder {
        Policy storage policy = policies[msg.sender];
        require(!policy.active, "Policy is already active");
        require(block.timestamp <= policy.expirationDate, "Policy expired");

        policy.active = true;
        emit PolicyActivated(msg.sender);
    }

    function deactivatePolicy() external onlyPolicyholder {
        Policy storage policy = policies[msg.sender];
        require(policy.active, "Policy is not active");

        policy.active = false;
        emit PolicyDeactivated(msg.sender);
    }

    function getPolicyDetails(address _policyholder) external view returns (Policy memory) {
        return policies[_policyholder];
    }
}
