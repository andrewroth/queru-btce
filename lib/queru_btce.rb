require 'cgi'
require 'json'
require 'net/http'
require 'openssl'
require 'open-uri'
require 'ostruct'

module QueruBtce
  @api_key = ''
  @api_secret = ''
  @last_nonce = Time.now.to_i

  def self.credentials(key: '', secret: '')
    @api_key = key
    @api_secret = secret
  end

  def self.trade_api(m, opts = {})
    opts[:method] = m
    opts[:nonce] = nonce
    payload = opts.collect do |key, val|
      "#{key}=#{CGI::escape(val.to_s)}"
    end.join('&')

    signature = OpenSSL::HMAC.hexdigest('sha512', @api_secret, payload)

    Net::HTTP.start('wex.nz', 443, use_ssl: true) do |http|
      headers = { 'Sign': signature, 'Key': @api_key }
      response = http.post('/tapi', payload, headers).body
      JSON.parse response, object_class: OpenStruct
    end
  rescue Net::HTTPUnauthorized
    raise 'Bad API credentials'
  rescue Net::HTTPError
    raise 'HTTP Error: API down?'
  end

  def self.public_api(m, *pair)
    if pair
      pair = pair.join('-') if pair.is_a? Array
      JSON.parse open("https://wex.nz/api/3/#{m}/#{pair}").read, object_class: OpenStruct
    else
      JSON.parse open("https://wex.nz/api/3/#{m}").read, object_class: OpenStruct
    end
  rescue OpenURI::HTTPError => e
    raise "BTC-e API down? #{e}"
  end

  def self.nonce
    new_nonce = Time.now.to_i
    while new_nonce <= @last_nonce
      sleep 1
      new_nonce = Time.now.to_i
    end
    @last_nonce = new_nonce
  end

  def self.trade_api_methods
    {
      get_info: 'getInfo',
      trade: 'Trade',
      cancel_order: 'CancelOrder',
      active_orders: 'ActiveOrders',
      trans_history: 'TransHistory',
      trade_history: 'TradeHistory',
      coin_deposit_address: 'CoinDepositAddress',
      withdraw_coin: 'WithdrawCoin'
    }
  end

  def self.public_api_methods
    {
      info: 'info',
      ticker: 'ticker',
      depth: 'depth',
      trades: 'trades'
    }
  end

  def self.method_missing(m, *args)
    if trade_api_methods.key? m
      trade_api trade_api_methods[m], *args
    elsif public_api_methods.key? m
      public_api public_api_methods[m], *args
    else
      super
    end
  end

  def self.respond_to_missing?(m, _include_all = false)
    return true if trade_api_methods.key?(m) or public_api_methods.key?(m)
    false
  end
end
