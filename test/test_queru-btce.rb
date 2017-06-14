require 'minitest/autorun'
require 'shoulda/context'
require 'QueruBtce'

class TestQueruBtce < Minitest::Test
  context 'QueruBtce Module' do
    setup do
      QueruBtce.credentials(key: 'mykey', secret: 'mysecret')
    end

    should 'respond to info' do
      assert_respond_to QueruBtce, 'info'
    end

    should 'get public info as an object' do
      assert_kind_of OpenStruct, QueruBtce.info
    end

    should 'see the server time' do
      assert_kind_of Integer, QueruBtce.info.server_time
    end

    should 'calc consecutive nonce' do
      assert QueruBtce.nonce < QueruBtce.nonce
    end

    should 'get a ticker' do
      assert_kind_of Numeric, QueruBtce.ticker(:btc_usd).btc_usd.last
    end

    should 'get several tickers' do
      assert_kind_of Numeric, QueruBtce.ticker(:btc_usd, :eth_usd).eth_usd.last
    end

    should 'get a pair depth orders' do
      assert_kind_of Array, QueruBtce.depth(:btc_usd).btc_usd.asks
    end

    should 'get several pair depth orders' do
      assert_kind_of Array, QueruBtce.depth(:btc_usd, :eth_usd).eth_usd.asks
    end

    should 'get a pair trades' do
      assert_kind_of Numeric, QueruBtce.trades(:btc_usd).btc_usd[0].price
    end

    should 'get several pair trades' do
      assert_kind_of Numeric, QueruBtce.trades(:btc_usd, :eth_usd).eth_usd[0].price
    end
  end
end
