var FreeCoin = artifacts.require('FreeCoin');

contract('FreeCoin', accounts => {

  it('should initialize with no tokens', () =>
    FreeCoin.deployed()
      .then(instance => instance.totalSupply())
      .then(supply   => assert.equal(supply, 0, 'total supply was not zero'))
  );

  it('should not distribute tokens until the specified block height', () =>
    FreeCoin.deployed()
      .then(instance => instance.distributeToken())
      .then(_        => assert(false, 'Exception contract to throw'))
      .catch(err     => assert(err.message.search('VM Exception while processing transaction: revert') >= 0, 'Expected contract to throw'))
  );

  it('should distribute tokens to registered addresses', () =>
    FreeCoin.deployed()
      .then(instance =>
        instance.registerAddresses([accounts[0]])
          .then(_ => instance.distributeToken())
          .then(_ => instance.ownerOf(0))
      )
      .then(owner =>
        assert.equal(accounts[0], owner, 'Unexpected account owner')
      )
  );

  // it('should distribute tokens to registered addresses', () => {
  //   return FreeCoin.deployed().then(instance =>
  //     instance.registerAddresses([accounts[0]])
  //       .then(_ => instance.distributeToken())
  //       .then(_ => instance.ownerOf(0))
  //   ).then(owner =>
  //     assert.equal(accounts[0], owner, 'Unexpected account owner')
  //   ).catch(e => console.log('Errrrrrrr', e));
  // });
});
