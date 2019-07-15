class Order < ApplicationRecord
  belongs_to :poll
  # belongs_to :position, class_name: "Position"
  monetize :price_cents

  after_create :execute, :post_to_alpaca
  before_action :set_stock_quote
  
  def set_stock_quote
    StockQuote::Stock.new(api_key: 'pk_5f4dbf25fbd3494cbbd71fe4c33393fe')
  end

  def execute
    @poll = self.poll
    @group = self.poll.group
    @position = @group.positions.find { |position| position.ticker == self.ticker}
    if @position.nil?
      @position = Position.new(
        ticker: @poll.ticker,
        quantity: @poll.quantity,
        current_price_cents: (StockQuote::Stock.quote(self.ticker).latest_price.to_f * 100).to_i,
        group_id: self.poll.group_id
      )
      @position.cost_basis_cents = (@position.quantity * @position.current_price)
    else
      @position.quantity += self.quantity if self.buy == true
      @position.cost_basis_cents += (self.quantity * (StockQuote::Stock.quote(self.ticker).latest_price.to_f * 100).to_i) if self.buy == true
      @position.quantity -= self.quantity if self.buy == false
      @position.cost_basis_cents -= (self.quantity * (StockQuote::Stock.quote(self.ticker).latest_price.to_f * 100).to_i) if self.buy == false
    end
    @group.cash_value_cents -= (self.price_cents * self.quantity) if self.buy == true
    @group.cash_value_cents += (self.price_cents * self.quantity) if self.buy == false
    @group.investment_value_cents -= (self.price_cents * self.quantity) if self.buy == false
    @group.investment_value_cents += (self.price_cents * self.quantity) if self.buy == true
    @position.return = (@position.current_price_cents * @position.quantity) - @position.cost_basis_cents
    @position.save!
    @position.destroy if @position.quantity.zero?
    @group.save!
    self.filled = true
    self.save!
  end

  def post_to_alpaca
    order_type = 'sell' if self.buy == false
    order_type = 'buy' if self.buy == true
    system("curl -X POST \
        -H \"APCA-API-KEY-ID:PK6U6ED9E8HXK3SWW268\" \
        -H \"APCA-API-SECRET-KEY:SouRAmDePmiQkyEEsiLItQx72dylQuMizDvFZpWI\"\
        -d \'{\"symbol\":\"#{self.ticker}\", \"qty\":\"#{self.quantity}\", \"side\":\"#{order_type}\", \"type\":\"market\", \"time_in_force\":\"gtc\"}\'\
        https://paper-api.alpaca.markets/v1/orders")
  end
end

# "https://paper-api.alpaca.markets/v1/account", headers: {"APCA-API-KEY-ID" => "PK6U6ED9E8HXK3SWW268","APCA-API-SECRET-KEY" => "SouRAmDePmiQkyEEsiLItQx72dylQuMizDvFZpWI"})
# orders?symbol=TSLA&qty=5&side=buy&type=market&time_in_force=gtc

# Unirest.get "https://paper-api.alpaca.markets/v1/account",
#                 "APCA-API-KEY-ID": "PK6U6ED9E8HXK3SWW268",
#                 "APCA-API-SECRET-KEY": "SouRAmDePmiQkyEEsiLItQx72dylQuMizDvFZpWI"

# Unirest.post "https://paper-api.alpaca.markets/v1/orders",
#                             "APCA-API-SECRET-KEY": "SouRAmDePmiQkyEEsiLItQx72dylQuMizDvFZpWI",
#                             "APCA-API-KEY-ID": "PK6U6ED9E8HXK3SWW268",
#                             parameters: {"symbol":"TSLA", "qty":"1", "side":"buy", "type":"market", "time_in_force":"day"}

# Faraday.get "https://paper-api.alpaca.markets/v1/account",
#             "APCA-API-KEY-ID": "PK6U6ED9E8HXK3SWW268",
#             "APCA-API-SECRET-KEY": "SouRAmDePmiQkyEEsiLItQx72dylQuMizDvFZpWI"

# Faraday.post "https://paper-api.alpaca.markets/v1/orders",
#                             "APCA-API-SECRET-KEY": "SouRAmDePmiQkyEEsiLItQx72dylQuMizDvFZpWI",
#                             "APCA-API-KEY-ID": "PK6U6ED9E8HXK3SWW268",
#                             parameters: {"symbol":"TSLA", "qty":"1", "side":"buy", "type":"market", "time_in_force":"day"}

# RestClient::Request.execute method: :get, url: "https://paper-api.alpaca.markets/v1/account", "APCA-API-KEY-ID": 'PK6U6ED9E8HXK3SWW268', "APCA-API-SECRET-KEY": 'SouRAmDePmiQkyEEsiLItQx72dylQuMizDvFZpWI'

# RestClient.post "https://paper-api.alpaca.markets/v1/orders",
# "APCA-API-KEY-ID": "PK6U6ED9E8HXK3SWW268",
# "APCA-API-SECRET-KEY": "SouRAmDePmiQkyEEsiLItQx72dylQuMizDvFZpWI",
# "Content-Type": "text/plain",
# {"symbol":"TSLA", "qty":"1", "side":"buy", "type":"market", "time_in_force":"day"}

# RestClient.post "https://paper-api.alpaca.markets/v1/orders", "APCA-API-KEY-ID": "PK6U6ED9E8HXK3SWW268", "APCA-API-SECRET-KEY": "SouRAmDePmiQkyEEsiLItQx72dylQuMizDvFZpWI", parameters: {"symbol":"TSLA", "qty":"1", "side":"buy", "type":"market", "time_in_force":"day"}
