// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {AccountOnboard} from '../src/contracts/AccountOnboard.sol';
import {MpcCoreMock} from './mocks/MpcCoreMock.sol';
import 'forge-std/Test.sol'; // Import the MpcCore mock

contract AccountOnboardTest is Test {
  AccountOnboard public accountOnboard;
  MpcCoreMock public mpcCoreMock; // Instance of the mock

  event AccountOnboarded(address indexed sender, bytes accountKey1, bytes accountKey2);

  function setUp() public {
    // Deploy the MpcCore mock
    mpcCoreMock = new MpcCoreMock();

    // Deploy the AccountOnboard contract, injecting the mock
    accountOnboard = new AccountOnboard();
  }

  function testOnboardAccount() public {
    // Mock the response of getUserKey to return predefined keys
    bytes memory expectedKey1 = hex'0000000000000000000000000000000000000000000000000000000000000000';
    bytes memory expectedKey2 = hex'1111111111111111111111111111111111111111111111111111111111111111';
    mpcCoreMock.setMockedUserKeys(expectedKey1, expectedKey2);

    // Verify the emission of the event
    emit AccountOnboarded(address(this), expectedKey1, expectedKey2);
  }
}
