pragma solidity ^0.4.24;


import "./StandardToken.sol";
import "./SafeMath.sol";

/**
* ERC20 compliant token for IndieOn ICO crowdfunding.
* Inital total supply is 100 million token
*/
contract IndieToken is StandardToken {

  string public constant name = "IndieOn Token";
  string public constant symbol = "INDIE";
  uint8 public constant decimals = 4;
  
  

  using SafeMath for uint256;
  uint256 public constant TOTAL_SUPPLY = 100000000 * (10 ** uint256(decimals));
  uint256 public constant icoTokenAmount = TOTAL_SUPPLY.div(100).mul(40); //40% for Total supply crowdsale
  uint256 public constant presaleAmount = (TOTAL_SUPPLY.div(100).mul(40)).div(100).mul(10); //10% of ICO for presale

  /**
   * @dev Constructor that gives msg.sender all of existing tokens.
   */
  constructor() public {
    totalSupply_ = TOTAL_SUPPLY;
    balances[msg.sender] = icoTokenAmount; //msg.sender will be address of IndieOnCrowdsale contract
   // balances[presaleAddress] = presaleAmount;
    emit Transfer(0x0, msg.sender, icoTokenAmount);
  }
}
