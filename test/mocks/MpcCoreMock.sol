// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

contract MpcCoreMock {
  bytes public mockedKey1;
  bytes public mockedKey2;

  // Establecer claves mockeadas
  function setMockedUserKeys(bytes memory key1, bytes memory key2) public {
    mockedKey1 = key1;
    mockedKey2 = key2;
  }
}
