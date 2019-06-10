class UserGroup < ApplicationRecord
  belongs_to :user
  belongs_to :group

  attr_accessor :initial_deposit, :deposit, :withdrawal

  def initial_deposit(deposit)
    self.user = current_user
    @group = Group.find(params[:group_id])
    newshares = deposit * 100
    @group.cash_value += deposit
    @group.total_shares += newshares
    self.user_contribution += deposit
    self.user_share += newshares
    self.user_balance = @group.portfolio_value * (self.user_share / @group.total_shares)
    self.save!
  end

  def deposits(deposit)
    @group = self.group
    @user = self.user
    newshares = deposit / (@group.portfolio_value / @group.total_shares)
    @group.cash_value += deposit
    @group.total_shares += newshares
    self.user_contribution += deposit
    self.user_share += newshares
    @group.portfolio_value = @group.cash_value + @group.investment_value
    self.user_balance = @group.portfolio_value * (self.user_share / @group.total_shares)
    self.user.available_balance -= deposit
    self.user.total_balance -= deposit
    @group.save!
    @user.save!
    self.save!
  end

  def withdraw(withdrawal)
    @group = self.group
    @user = self.user
    cancelledshares = withdrawal / (@group.portfolio_value / @group.total_shares)
    @group.cash_value -= withdrawal
    @group.total_shares -= cancelledshares
    self.user_contribution -= withdrawal
    self.user_share -= cancelledshares
    @group.portfolio_value = @group.cash_value + @group.investment_value
    self.user_balance = @group.portfolio_value * (self.user_share / @group.total_shares)
    @user.available_balance += withdrawal
    @user.total_balance += withdrawal
    @group.save!
    @user.save!
    self.save!
  end
end
