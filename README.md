# queru-btce

KISS BTC-E API Access from Ruby.

### Pros:

- No config file and no framework dependency.
- No weird abstractions, you can follow BTC-e API specs.
- Returns an object, keys are methods.
- Really few error abstraction, exceptions are raised.
- Nounce is enforced, I don't expect damm nounce error.
- Tests for the public API (rake test).

### Cons:

- Not much abstraction, you should know BTC-e API.
- Its in **BETA** status. Not production tested until now.

## Installation

Gemfile:

```ruby
gem 'queru-btce'
```

Execute:

```bash
$ bundle
```

Or install:

```bash
$ gem install queru-btce
```

## Usage

This gem provides class methods for all public/private API methods offered by BTC-e.
Responses are hashes and any errors are raised as exception, your program can handle it.

- [BTC-E Trade API Documentation](https://btc-e.com/api/documentation)
- [BTC-E Public API Documentation](https://btc-e.com/api/3/docs)

You can call any BTC-e API methods this way:

```ruby
QueruBtce.info

QueruBtce.ticker(:btc_usd)

QueruBtce.ticker(:btc_usd, :eth_usd)
```

More docs to come.

## Contributing

Pull requests, issues and comments are welcome the most of the days.

## Thanks

To [Brock Harris](https://github.com/BrockHarris), I did started from his gem.
