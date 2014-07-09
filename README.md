# hyperledger Reference Server

This is a reference server for the hyperledger protocol for implementing
decentralised ledgers.

# Status

This software is still young and under active development. None of the interfaces are
stable yet and there are known bugs and omissions in the implementation. Use at your
own risk.

## Setup

This reference server is a fairly straightforward Rails application so standard Rails setup
instructions apply.

Two env vars are needed to run the app: `NODE_URL` which is the URL where the node will run,
and `PRIVATE_KEY` which is a 2048 bit RSA private key. You can set these in your environment or
in a `.env` file.

You will also need to seed the database with the `ConsensusNode`s. At a minimum you need a record
corresponding to the currently running node; `url` should be the same as `NODE_URL` and `public_key`
should be the matching key to the `PRIVATE_KEY`.

You can generate RSA keypairs in Ruby:

    require 'openssl'
    key = OpenSSL::PKey::RSA.new(2048)
    key.to_pem # Private key
    key.publci_key.to_pem # Public key

## License

hyperledger Reference Server is released under the [MIT License](http://www.opensource.org/licenses/MIT).