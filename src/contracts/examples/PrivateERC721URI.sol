// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import '@coti-io/coti-contracts/contracts/token/PrivateERC721/extensions/PrivateERC721URIStorage.sol';

contract MyNFT is PrivateERC721URIStorage {
  constructor() PrivateERC721('Private NFT', 'PNFT') {}

  function mintWithIPFS(address to, uint256 tokenId, itString calldata uri) external {
    _safeMint(to, tokenId);
    _setTokenURI(to, tokenId, uri);
  }
}
