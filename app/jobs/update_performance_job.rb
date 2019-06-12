class UpdatePerformanceJob < ApplicationJob
  queue_as :default

  def update_position(position)
    position = Position.find(position)
    puts "Updating position #{position.id}"
    position.current_price_cents = cents(StockQuote::Stock.quote(position.ticker).latest_price)
    position.return_cents = (@position.current_price_cents * @position.quantity) - @position.cost_basis_cents
    puts "Done"
  end

  def update_group(group)
    group = Group.find(group)
    puts "Updating group #{group.id}"
    new_total = 0
    group.positions.each do |position|
      new_total += (position.current_price_cents * position.quantity)
    end
    group.investment_value_cents = new_total
    group.portfolio_value_cents = group.investment_value_cents + group.cash_value_cents
    group.performance[Date.today.strftime("%d-%m-%Y")] = group.portfolio_value_cents
    puts "Done"
  end

  def update_user(user)
    user = User.find(user)
    puts "Updating user #{user.id}"
    new_total = 0.0
    user.groups.each do |group|
      user_group = group.user_groups.where(user_id: user.id).first
      new_total += group.portfolio_value_cents * (user_group.user_share.to_f / group.total_shares)
    end
    user.total_balance_cents = new_total + user.available_balance_cents
    # user.performance[Date.today.strftime("%d-%m-%Y")] = user.total_balance
    puts "Done"
  end

  def perform
    puts "Beginning positions update"
    Position.all.each do |position|
      update_position(position)
    end
    puts "Finishing positions update"

    puts "Beginning groups update"
    Group.all.each do |group|
      update_group(group)
    end
    puts "Finishing groups update"

    puts "Beginning users update"
    User.all.each do |user|
      update_user(user)
    end
    puts "Finishing users update"
  end
end
