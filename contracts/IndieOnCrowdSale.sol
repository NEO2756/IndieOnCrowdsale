pragma solidity ^0.4.24;

import "./IndieToken.sol";

contract IndieOnCrowdSale {
  using SafeMath for uint256;

  // The token being sold
  IndieToken public token;

  // Address where funds are collected
  address public wallet;
  uint256 public rate;
  uint256 public openingTime;
  uint256 public closingTime;
  uint256 public weiRaised;
  
  uint256 public  FirstWeekEnd;
  uint256 public  SecoundWeekStart;

  event TokenPurchase(
    address indexed purchaser,
    address indexed beneficiary,
    uint256 value,
    uint256 amount
  );

  /**
   * @param _rate Number of token units a buyer gets per wei
   * @param _wallet Address where collected funds will be forwarded to
   */
  constructor(uint256 _rate, address _wallet, uint _openingTime, uint _closingTime)
   public
   {
    require(_rate > 0);
    require(_wallet != address(0));

    rate = _rate;
    wallet = _wallet;
    token = new IndieToken();
    openingTime = _openingTime;
    closingTime = _closingTime;
  }

  modifier onlyWhileOpen {
    require(block.timestamp >= openingTime && block.timestamp <= closingTime);
    _;
  }

  function hasClosed() public view returns (bool) {
    return block.timestamp > closingTime;
  }

  // -----------------------------------------
  // Crowdsale external interface
  // -----------------------------------------

  /**
   * @dev fallback function ***DO NOT OVERRIDE***
   */
  function () external payable {
    buyTokens(msg.sender);
  }

  function buyTokens(address _beneficiary) public payable {

    uint256 weiAmount = msg.value;
    _preValidatePurchase(_beneficiary, weiAmount);

    // calculate token amount to be created
    uint256 tokens = getTokenAmount(weiAmount);
    // update state
    weiRaised = weiRaised.add(weiAmount);

    _processPurchase(_beneficiary, tokens);
        emit TokenPurchase(
        msg.sender,
       _beneficiary,
        weiAmount,
        tokens
     );

    _forwardFunds();
  }

  function _preValidatePurchase(
    address _beneficiary,
    uint256 _weiAmount
  )
    onlyWhileOpen
    internal
  {
    require(_beneficiary != address(0));
    require(_weiAmount != 0);
  }

  /**
   * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
   * @param _beneficiary Address performing the token purchase
   * @param _tokenAmount Number of tokens to be emitted
   */
  function _deliverTokens(
    address _beneficiary,
    uint256 _tokenAmount
  )
    internal
  {
    token.transfer(_beneficiary, _tokenAmount);
  }

  /**
   * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
   * @param _beneficiary Address receiving the tokens
   * @param _tokenAmount Number of tokens to be purchased
   */
  function _processPurchase(
    address _beneficiary,
    uint256 _tokenAmount
  )
    internal
  {
    _deliverTokens(_beneficiary, _tokenAmount);
  }

  /**@dev Calculate the discount based on the current phase of sale.
   * @return Percentage of discount
   */
    function getDiscount() onlyWhileOpen internal returns (uint256) {
        if (now < FirstWeekEnd) // we are in first week
        return 160;
        else if (now > FirstWeekEnd && now < SecoundWeekStart) // in secound week
        return 130;
        else
        return 110;  //in third OR forth week
    }
    
  /**
   * @dev Override to extend the way in which ether is converted to tokens.
   * @param _weiAmount Value in wei to be converted into tokens
   * @return Number of tokens that can be purchased with the specified _weiAmount
   */
  function getTokenAmount(uint256 _weiAmount)
    internal view returns (uint256)
  {
    uint discount = getDiscount();
    return _weiAmount.div(100).mul(discount);
  }

  /**
   * @dev Determines how ETH is stored/forwarded on purchases.
   */
  function _forwardFunds() internal {
    wallet.transfer(msg.value);
  }
}
