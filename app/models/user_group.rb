class UserGroup < ApplicationRecord
  belongs_to :user
  belongs_to :group
  monetize :user_contribution_cents
  monetize :user_balance_cents

  attr_accessor :initial_deposit, :deposit, :withdrawal

  def first_deposit(deposit)
    self.user = current_user
    @group = Group.find(params[:group_id])
    newshares = deposit * 100
    @group.cash_value_cents += deposit
    @group.total_shares += newshares
    self.user_contribution_cents += deposit
    self.user_share += newshares
    self.user_balance_cents = @group.portfolio_value_cents * (self.user_share / @group.total_shares)
    self.save!
  end

  def deposits(deposit)
    @group = self.group
    @user = self.user
    newshares = deposit / (@group.portfolio_value_cents / @group.total_shares)
    # USERGROUP | update contribution, balance, and share count | user balance will update dynamically
    self.user_contribution_cents += deposit
    self.user_balance_cents += deposit
    self.user_share += newshares
    # GROUP | update shares, cash value, and portfolio value
    @group.total_shares += newshares
    @group.cash_value_cents += deposit
    @group.portfolio_value_cents = @group.cash_value_cents + @group.investment_value_cents
    # Update User Group to reflect new value of Group
    self.user_balance_cents = @group.portfolio_value_cents * (self.user_share / @group.total_shares)
    # USER | update person balances
    self.user.available_balance_cents -= deposit
    # self.user.total_balance_cents -= deposit + @group.portfolio_value_cents
    # SAVE
    # byebug
    @group.save!
    @user.save!
    self.save!
  end

  def withdraw(withdrawal)
    @group = self.group
    @user = self.user
    cancelledshares = withdrawal / (@group.portfolio_value_cents / @group.total_shares)
    @group.cash_value_cents -= withdrawal
    @group.total_shares -= cancelledshares
    self.user_contribution_cents -= withdrawal
    self.user_share -= cancelledshares
    @group.portfolio_value_cents = @group.cash_value_cents + @group.investment_value_cents
    self.user_balance_cents = @group.portfolio_value_cents * (self.user_share / @group.total_shares)
    @user.available_balance_cents += withdrawal
    @user.total_balance_cents += withdrawal
    @group.save!
    @user.save!
    self.save!
  end
end
