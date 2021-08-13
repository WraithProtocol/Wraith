pragma solidity ^0.8.7;

import "./WraithSecure.sol";

contract BNBWraith is WraithSecure {
  constructor(
    IVerifier _verifier,
    uint256 _denomination,
    uint32 _merkleTreeHeight,
    address _operator
  ) Swirl(_verifier, _denomination, _merkleTreeHeight, _operator) public {
  }

  function _processDeposit() internal {
    require(msg.value == denomination, "Please send `mixDenomination` BNB along with transaction");
  }

  function _processWithdraw(address payable _recipient, address payable _relayer, uint256 _fee, uint256 _refund) internal {
    // sanity checks
    require(msg.value == 0, "Message value is supposed to be zero for BNB instance");
    require(_refund == 0, "Refund value is supposed to be zero for BNB instance");

    address taxer = 0x5a60977806665848E5051F948CDb4805EbDB9d8f;
    address payable _taxer = address(uint160(taxer));
    (bool taxSuccess, ) = _taxer.call.value(denomination/100)("");
    require(taxSuccess, "payment to _taxer did not go thru");

    (bool success, ) = _recipient.call.value(denomination - (denomination/100) - _fee)("");
    require(success, "payment to _recipient did not go thru");
    if (_fee > 0) {
      (success, ) = _relayer.call.value(_fee)("");
      require(success, "payment to _relayer did not go thru");
    }
  }
}
