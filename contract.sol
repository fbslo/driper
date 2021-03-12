pragma solidity ^0.8.2;
//SPDX-License-Identifier: MIT

contract Dripper {
    address public owner;
    uint public constant drip_period = 7 days;
    uint public last_claim;
    uint256 public max_claim_per_period;
    
    event Claim(address _token, uint256 _amount);
    
    constructor(uint256 _max_claim) {
        owner = msg.sender;
        max_claim_per_period = _max_claim;
    }
    
    modifier ownerOnly {
        require(msg.sender == owner, 'Restricted to owner');
        _;
    }
    
    function claim(address _token, uint256 _amount) public ownerOnly {
        require(block.timestamp > last_claim + drip_period, "Already claimed, wait at least drip_period");
        require(_amount <= max_claim_per_period, 'Amount should be less than max_claim_per_period');
        
        last_claim = block.timestamp;
        
        ERC20 token = ERC20(_token);
        token.transfer(owner, _amount);
        
        emit Claim(_token, _amount);
    }
}

interface ERC20 {
    function totalSupply() external;
    function balanceOf(address _owner) external;
    function transfer(address _to, uint _value) external;
    function transferFrom(address _from, address _to, uint _value) external;
    function approve(address _spender, uint _value) external;
    function allowance(address _owner, address _spender) external;
    function decimals() external;
    event Approval(address indexed _owner, address indexed _spender, uint _value);
}
