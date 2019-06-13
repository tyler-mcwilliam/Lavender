class UpdatePerformanceJob < ApplicationJob
  queue_as :default

  def update_position(position)
    # position = Position.find(position)
    puts "Updating position #{position.id}"
    position.current_price_cents = (StockQuote::Stock.quote(position.ticker).latest_price.to_f * 100).to_i
    position.return_cents = (position.current_price_cents - position.cost_basis_cents) * position.quantity
    position.save!
    puts "Done"
  end

  def update_group(group)
    # group = Group.find(group)
    puts "Updating group #{group.id}"
    new_total = 0
    group.positions.each do |position|
      new_total += (position.current_price_cents * position.quantity)
    end
    group.investment_value_cents = new_total
    group.portfolio_value_cents = group.investment_value_cents + group.cash_value_cents
    group.performance << { "date": Date.today.strftime("%Y-%m-%d-%H-%M"), "value": group.portfolio_value_cents }
    group.save!
    puts "Done"
  end

  def update_user_group(user_group)
    # user = UserGroup.find(user)
    puts "Updating user group #{user_group.id}"
    user_group.user_balance_cents = user_group.group.portfolio_value_cents * (user_group.user_share.to_f / user_group.group.total_shares)
    user_group.save!
    puts "Done"
  end

  def update_user(user)
    # user = User.find(user)
    puts "Updating user #{user.id}"
    new_total = 0
    user.user_groups.each do |user_group|
      new_total += user_group.user_balance_cents
    end
    user.total_balance_cents = new_total + user.available_balance_cents
    # user.performance[Date.today.strftime("%d-%m-%Y")] = user.total_balance
    user.save!
    puts "Done"
  end

  def perform
    puts "Enqueuing update of #{Position.all.count} positions..."
    Position.all.each do |position|
      update_position(position)
    end
    puts "Finishing positions update"

    puts "Enqueuing update of #{Group.all.count} groups..."
    Group.all.each do |group|
      update_group(group)
    end
    puts "Finishing groups update"

    puts "Enqueuing update of #{UserGroup.all.count} user groups..."
    UserGroup.all.each do |user_group|
      update_user_group(user_group)
    end
    puts "Finishing user groups update"

    puts "Enqueuing update of #{User.all.count} users..."
    User.all.each do |user|
      update_user(user)
    end
    puts "Finishing users update"
  end
end
