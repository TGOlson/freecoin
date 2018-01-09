# freecoin

the coins are free

#### initial setup

```
$ npm install -g truffle
$ truffle develop

truffle(develop)> migrate
develop
  Replacing FreeCoin...
  ... 0x12209be5272dd7a16130d0f4e89e5af9a9826a70e5b2141b00516c9ba4003648
  FreeCoin: <contract address>
  ...
```

Copy output `<contract address>` into `app/index.html` -> `const freeCoin = FreeCoin.at(<contract address>);`

```
$ open app/index.html
```

#### dev

```
$ truffle develop

truffle(develop)> test/migrate/compile
```

#### notes

* https://github.com/ethereum/eips/issues/721
* https://github.com/dharmaprotocol/NonFungibleToken/blob/master/contracts/NonFungibleToken.sol
* https://theethereum.wiki/w/index.php/ERC20_Token_Standard
* http://truffleframework.com/docs/getting_started/project
* https://github.com/dob/auctionhouse
* https://medium.com/@petkanics/introducing-auctionhouse-an-ethereum-dapp-for-auctioning-on-chain-goods-c91244bde469
* https://remix.ethereum.org/#optimize=false&version=soljson-v0.4.19+commit.c4cbbb05.js
* ["0xca35b7d915458ef540ade6068dfe2f44e8fa733c"]
* ["0xca35b7d915458ef540ade6068dfe2f44e8fa733c", "0x14723a09acff6d2a60dcdf7aa4aff308fddc160c", "0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db"]
* https://ethgasstation.info/calculatorTxV.php
