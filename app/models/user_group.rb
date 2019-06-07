class UserGroup < ApplicationRecord
  belongs_to :user
  belongs_to :group

  def initial_deposit(deposit)
    @user_group.user = current_user
    @group = Group.find(params[:group_id])
    newshares = deposit * 100
    @group.cash_value += deposit
    @group.total_shares += newshares
    @user_group.user_contribution += deposit
    @user_group.user_share += newshares
    @user_group.user_balance = @group.investment_value * (@user_group.user_share / @group.total_shares)
    @user_group.save
  end

  def deposit(deposit)
    @group = Group.find(params[:group_id])
    newshares = deposit / (@group.investment_value / @group.total_shares)
    @group.cash_value += deposit
    @group.total_shares += newshares
    @user_group.user_contribution += deposit
    @user_group.user_share += newshares
    @user_group.user_balance = @group.investment_value * (@user_group.user_share / @group.total_shares)
    @user_group.save
  end

  def withdraw(withdrawal)
    @group = self.group
    cancelledshares = withdrawal / (@group.investment_value / @group.total_shares)
    @group.cash_value -= withdrawal
    @group.total_shares -= cancelledshares
    @user_group.user_contribution -= withdrawal
    @user_group.user_share -= cancelledshares
    @user_group.user_balance = @group.investment_value * (@user_group.user_share / @group.total_shares)
    @user_group.save
  end

  attr_accessor :initial_deposit, :deposit, :withdrawal
end
