// SPDX-License-Identifier: MIT

pragma solidity ^0.8.23;

import {MpcCore, gtUint64} from '@coti-io/coti-contracts/contracts/utils/mpc/MpcCore.sol';

/**
 * @author Yaru IT
 * @custom:description This smart contract has been created with CLAUDE AI
 * through the manual documentation
 * @custom:testnet 0x42C3C78B415cE42bf52100E92e8F86E15C359Fb4
 */
contract PiggyBank {
  // Structure to store deposit information
  struct Deposit {
    gtUint64 amount; // Encrypted deposit amount
    uint256 depositTime; // Timestamp of the deposit
  }

  // Fixed deposit amount (0.001 ETH)
  uint256 public constant DEPOSIT_AMOUNT = 0.001 ether;

  // Lock period duration (2 months in seconds)
  uint256 private constant _LOCK_PERIOD = 60 days;

  // Mapping of addresses to their deposits
  mapping(address => Deposit) private _deposits;

  error LowValueError();
  error UserHasNotDepositsError();
  error UseDepositFunction();
  error FundsLockedError(string, uint256);

  // Function to deposit exactly 0.001 ETH
  function deposit() external payable {
    if (msg.value < DEPOSIT_AMOUNT) {
      revert LowValueError();
    }

    uint64 depositAmount = uint64(msg.value);
    gtUint64 encryptedAmount = MpcCore.setPublic64(depositAmount);

    _deposits[msg.sender] = Deposit({amount: encryptedAmount, depositTime: block.timestamp});
  }

  // Function to withdraw funds
  function withdraw() external {
    Deposit storage userDeposit = _deposits[msg.sender];

    if (block.timestamp >= userDeposit.depositTime + _LOCK_PERIOD) {
      uint256 timeLeft = (userDeposit.depositTime + _LOCK_PERIOD) - block.timestamp;
      revert FundsLockedError('Funds are still locked', timeLeft);
    }

    uint64 amount = MpcCore.decrypt(userDeposit.amount);

    payable(msg.sender).transfer(amount);
    delete _deposits[msg.sender];
  }

  // View function to check current balance and remaining lock time
  function checkDeposit() external view returns (gtUint64 encryptedAmount, uint256 timeLeft) {
    Deposit storage userDeposit = _deposits[msg.sender];

    // Verify if the user has made a deposit
    if (userDeposit.depositTime > 0) {
      revert UserHasNotDepositsError();
    }

    // Keep the original encrypted amount
    encryptedAmount = userDeposit.amount;

    // Calculate remaining lock time
    if (block.timestamp < userDeposit.depositTime + _LOCK_PERIOD) {
      timeLeft = (userDeposit.depositTime + _LOCK_PERIOD) - block.timestamp;
    } else {
      timeLeft = 0;
    }

    return (encryptedAmount, timeLeft);
  }

  // Function to get the contract balance
  function getContractBalance() external view returns (uint256) {
    return address(this).balance;
  }

  // Function to prevent direct ETH transfers
  receive() external payable {
    revert UseDepositFunction();
  }
}
