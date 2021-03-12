pragma solidity ^0.8.2;
//SPDX-License-Identifier: MIT

contract Dripper {
    address public owner;
    
    uint public start;
    uint public drip_period = 7 days;
    
    uint256 public unlock_per_second;
    uint256 public already_claimed;
    
    event Claim(address _token, uint256 _amount);
    
    constructor() {
        owner = msg.sender;
        start = block.timestamp;
        unlock_per_second = 636574070000000; //0.00063657407 CUB, 385 per week, 18 decimal places
    }
    
    modifier ownerOnly {
        require(msg.sender == owner, 'Restricted to owner');
        _;
    }
    
    function claim(address _token, uint256 _amount) public ownerOnly {
        uint256 time_from_start = block.timestamp - start;
        uint256 allowed_to_claim = time_from_start * unlock_per_second;
        
        require(_amount >= (allowed_to_claim - already_claimed), "Claim less!");

        ERC20 token = ERC20(_token);
        token.transfer(owner, _amount);
        
        already_claimed += _amount;
        
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
