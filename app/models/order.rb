class Order < ApplicationRecord
  belongs_to :poll
  # belongs_to :position, class_name: "Position"

  after_create :execute

  def execute
    @poll = self.poll
    @group = self.poll.group
    @position = @group.positions.where(:ticker == self.ticker).first
    if @position.nil?
      @position = Position.new(
        ticker: @poll.ticker,
        quantity: @poll.quantity,
        current_price: StockQuote::Stock.quote(self.ticker).latest_price,
        group_id: self.poll.group_id
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
    @position.destroy if @position.quantity == 0
    self.filled = true
    self.save!
  end
end
