require "QueruBtce/version"
require 'json'
require 'open-uri'
require 'httparty'
require 'ostruct'

module QueruBtce
  @api_key = false
  @api_secret = false
  @last_nonce = Time.now.to_i

  def credentials(key, secret)
    @api_key = key
    @api_secret = secret
  end

	def self.return_error
    raise "BTC-e error: Invalid parameters/credentials, or too many requests."
	end

  def pairs
    {
      btc_usd: 3,
      btc_eur: 3,
      btc_rur: 4,
      eur_usd: 4,
      eur_rur: 4,
      ftc_btc: 4,
      nvc_btc: 4,
      nvc_usd: 4,
      ppc_btc: 4,
      usd_rur: 4,
      ppc_usd: 4,
      ltc_rur: 4,
      nmc_btc: 4,
      ltc_btc: 5,
      ltc_eur: 6,
      ltc_usd: 6,
      nmc_usd: 6,
      trc_btc: 6,
      xpm_btc: 6
    }
  end

  def self.round_off(value, places)
    (value.to_f * (10 ** places)).floor / (10.0 ** places)
  end

  def self.cleanup_trade_params(opts)
    raise "Unknown pair '#{opts[:pair]}'" unless pairs.include? opts[:pair]
    opts.merge(pair: opts[:pair],
               rate: round_off(opts[:rate], pairs[opts[:pair]]),
               amount: round_off(opts[:amount], 8))
  end

  def self.api(method, opts)
    opts = cleanup_trade_params(opts) if method == 'Trade' and not opts.empty?

    payload = opts.collect do |key, val|
      "#{key}=#{CGI::escape(val.to_s)}"
    end.join('&')

    signature = OpenSSL::HMAC.hexdigest('sha512', @api_secret, payload)

    Net::HTTP.start('btc-e.com', 443, :use_ssl => true) do |http|
      headers = {'Sign' => signature, 'Key' => @api_key}
      response = http.post('/tapi', payload, headers).body
      begin
        return JSON.parse response, object_class: OpenStruct
      rescue StandarError
        raise "Invalid API response: #{response}"
      end
    end
  end

  def self.nonce
    sleep 1 while result = Time.now.to_i and @last_nonce and @last_nonce >= result
    @last_nonce = result
  end

  def self.all_currencies
      'btc_usd-btc_rur-btc_eur-btc_cnh-btc_gbp-ltc_btc-ltc_usd-ltc_rur-ltc_eur-ltc_cnh-ltc_gbp-nmc_btc-nmc_usd-' \
    + 'nvc_btc-nvc_usd-usd_rur-eur_usd-eur_rur-usd_cnh-gbp_usd-trc_btc-ppc_btc-ppc_usd-ftc_btc-xpm_btc'
  end

	def self.account
  	request = QueruBtce.api('getInfo', opts = {})
   	return request.return if request.success.positive?
    raise request.error
  end

  def self.new_trade(opts = {})
    request = api 'Trade', opts
    return request.return if request.success.positive?
    raise request.error
  end

  def self.cancel(opts = {})
    request = QueruBtce.api("CancelOrder", opts)
    return request.return if request.success.positive?
    raise request.error
  end

  def self.orders(opts={})
    request = QueruBtce.api("ActiveOrders", opts)
    return request.return if request.success.positive?
    raise request.error
  end

  def self.transactions(opts={})
  	request = QueruBtce.api("TransHistory", opts)
    return request.return if request.success.positive?
    raise request.error
    end
  end

  def self.trades(opts={})
    request = QueruBtce.api("TradeHistory", opts)
    return request.return if request.success.positive?
    raise request.error
  end

  def self.ticker(currency = :all)
    currencies = currency
    currencies = all_currencies if currency == :all
  	request = JSON.parse open("https://btc-e.com/api/3/ticker/#{currencies}").read, object_class: OpenStruct
    return request if request.success.positive? and currency == :all
    return request[currency] if request.success.positive?
    raise request.error
  end

  def self.pair_info
  	request = JSON.parse open("https://btc-e.com/api/3/info").read, object_class: OpenStruct
  	return request[:pairs] if request.success.positive?
    raise request.error
  end

  def self.depth(limit)
    JSON.parse open("https://btc-e.com/api/3/depth/#{all_currencies}?limit=#{limit}").read, object_class: OpenStruct
  end

  def self.order_book(limit)
  	JSON.parse(open("https://btc-e.com/api/3/trades/#{self.all_currencies}?limit=#{limit}").read,
               object_class: OpenStruct)
  end
end
