// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import {AccountOnboard} from 'contracts/AccountOnboard.sol';
import {Script} from 'forge-std/Script.sol';

contract Deploy is Script {
  function run() public {
    vm.startBroadcast();
    new AccountOnboard();
    vm.stopBroadcast();
  }
}
