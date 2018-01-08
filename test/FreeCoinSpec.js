var FreeCoin = artifacts.require('FreeCoin');

const skipBlocks = (instance, x) =>
  x > 0 ? instance.blockNum().then(_ => skipBlocks(instance, x - 1)) : null;

contract('FreeCoin', accounts => {
  it('should initialize with no tokens', () =>
    FreeCoin.new()
      .then(instance => instance.totalSupply())
      .then(supply   => assert.equal(supply, 0, 'total supply was not zero'))
  );

  it('should not distribute tokens before the required block height', () =>
    FreeCoin.new().then(instance => {
      instance.registerAddresses([accounts[0]]);

      instance.distributeToken()
        .then(_    => assert(false, 'Exception contract to throw'))
        .catch(err => assert(err.message.search('VM Exception while processing transaction: revert') >= 0, 'Expected contract to throw'))
    })
  );

  it('should distribute tokens to a registered address', () =>
    FreeCoin.new().then(instance => {
      skipBlocks(instance, 1);

      instance.registerAddresses([accounts[0]]);
      instance.distributeToken();

      instance.ownerOf(0).then(owner =>
        assert.equal(accounts[0], owner, 'Unexpected account owner')
      );
    })
  );
});
