class Order < ApplicationRecord
  belongs_to :poll
  belongs_to :group
  # belongs_to :position, class_name: "Position"

  after_create :execute

  def execute
    @position = Position.find(ticker == self.ticker)
    if Position.find(ticker == self.ticker).nil?
      @position = Position.new(
        ticker: @poll.ticker,
        quantity: @poll.quantity,
        current_price: StockQuote::Stock.quote(self.ticker).latest_price,
        group_id: self.group_id
      )
      @position.cost_basis = (@position.quantity * @position.current_price)
    else
      @position.quantity += self.quantity if self.buy == true
      @position.cost_basis += (self.quantity * StockQuote::Stock.quote(self.ticker).latest_price) if self.buy == true
      @position.quantity -= self.quantity if self.buy == false
      @position.cost_basis -= (self.quantity * StockQuote::Stock.quote(self.ticker).latest_price) if self.buy == false
    end
    @position.return = (@position.current_price * @position.quantity) - @position.cost_basis
    @position.save!
    self.filled = true
    self.save!
  end
end
