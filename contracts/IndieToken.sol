pragma solidity ^0.4.24;


import "../../node_modules/openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol";

/**
* ERC20 compiant token for IndieON ICO crowdfunding.
* Inital total supply is 100 million token
*/
contract IndieToken is StandardToken {

  string public constant name = "IndieOn Token";
  string public constant symbol = "INDIE";
  uint8 public constant decimals = 4;

  uint256 public constant INITIAL_SUPPLY = 10000 * (10 ** uint256(decimals));

  /**
   * @dev Constructor that gives msg.sender all of existing tokens.
   */
  constructor() public {
    totalSupply_ = INITIAL_SUPPLY;
    balances[msg.sender] = INITIAL_SUPPLY;
    emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
  }
}
