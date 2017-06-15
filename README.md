# QueruBtce

KISS _BTC-e_ API Access from Ruby.

[![Gem Version](https://badge.fury.io/rb/queru_btce.svg)](https://badge.fury.io/rb/queru_btce)

### Pros:

- No config file and no framework dependency.
- No weird abstractions, you can follow _BTC-e_ API specs.
- Returns an object, keys are methods.
- Really few error abstraction, exceptions are raised.
- Nounce is enforced, I don't expect damm nounce error.
- Tests for the public API (rake test).
- Fast and lightweight: A small module.
- I did used every other gem and still needing this one.

### Cons:

- Not much abstraction, you should know _BTC-e_ API.
- Its new, so I don't know a lot of people using it in production.

## Installation

Gemfile:

```ruby
gem 'queru_btce'
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

This gem provides class methods for all public/private API methods offered by _BTC-e_.
Responses are objects (dot methods or hash access) and any errors are raised as exception, your program can handle it.

- [_BTC-e_ Trade API Documentation](https://btc-e.com/api/documentation)
- [_BTC-e_ Public API Documentation](https://btc-e.com/api/3/docs)

In _BTC-e_ API some methods are _CamelCase_. In this gem those method must be called in _snake_case_ format. For example `TradeHistory` becomes `QueruBtce.trade_history`.

You can call any _BTC-e_ API method this way:

#### Public API example:
```ruby
info = QueruBtce.info
puts info.server_time

btc_usd = QueruBtce.ticker(:btc_usd)
puts btc_usd.ask
puts btc_usd.bid

QueruBtce.ticker(:btc_usd).btc_usd.last
mytickers = QueruBtce.ticker(:btc_usd, :eth_usd, :ltc_usd)
puts "BTC: #{mytickers.btc_usd.last}"
puts "ETH: #{mytickers.eth_usd.last}"
puts "LTC: #{mytickers.ltc_usd.last}"
```

#### Public API methods:

All the described at _BTC-e_ documentation:

```ruby
QueruBtce.info
QueruBtce.ticker
QueruBtce.depth
QueruBtce.trades
```

#### Private API example:
```ruby
QueruBtce.credentials key: 'mykey', secret: 'mysecret'
my_info = QueruBtce.get_info
puts my_info.return.funds.btc

orders = QueruBtce.active_orders pair: :btc_usd
puts 'I have open orders' if orders.return
```

#### Trade API methods:


All the described at _BTC-e_ documentation. Parameters are passed as hash, for example:

```ruby
QueruBtce.trans_history from: 0, count: 100, order: 'ASC'
```

The list is:

```ruby
QueruBtce.get_info
QueruBtce.trans_history
QueruBtce.trade_history
QueruBtce.active_orders
QueruBtce.trade
QueruBtce.cancel_order
```

## Tips:

### Nounce error and locking:

Nounce is param required by _BTC-e_ trade api, is just an integer but the current one should be greater than the last one. I guess they require it to ensure your transactions are received in a known order, sequentially.

This gem always send a timestamp as nounce, ensuring its greater than the last one, so calls are delayed a second between. Not a real problem because API can dump you out when try to ask faster.

But if you are calling the API from more than one process, there's no locking mechanism in gem (maybe in the future) and you need to implement a lock to prevent making two calls at once. A cache key, or distributed message can do the work, even a semaphore file locking.

It remains at your side by the moment.

## Contributing

Pull requests, issues and comments are welcome the most of the days.

## Thanks

To [Brock Harris](https://github.com/BrockHarris), I did started from his gem.
