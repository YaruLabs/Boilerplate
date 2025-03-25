// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

interface IAccountOnboard {
  event AccountOnboarded(address indexed _from, bytes userKey1, bytes userKey2);

  /**
   * @notice onboards the account and emits the users AES encryption key in encrypted form
   * @dev the AES key must be decrypted in order to be used to pass encrypted data to the chain
   * @param publicKey RSA public key
   * @param signedEK signed hash of the RSA public key
   */
  function onboardAccount(bytes calldata publicKey, bytes calldata signedEK) external;
}
