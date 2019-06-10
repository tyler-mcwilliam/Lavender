class UpdatePerformanceJob < ApplicationJob
  queue_as :default

  def update(group)
    puts "Beginning groups update"
    new_total = 0.0
    group.positions.each do |position|
      position.current_price = StockQuote::Stock.quote(position.ticker).latest_price
      position.return = (@position.current_price * @position.quantity) - @position.cost_basis
      new_total += (position.current_price * position.quantity)
    end
    group.investment_value = new_total
    group.portfolio_value = group.investment_value + group.cash_value
    group.performance[:Date.today] = group.portfolio_value
    puts "Finishing groups update"
  end
end
