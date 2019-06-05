class UserGroupsController < ApplicationController
  attr_accessor :deposit, :withdraw
  def new
    @user_group = UserGroup.new
  end

  def update
    # Currenty using params[:deposit] as a placeholder for user's initial deposit.
    # Assuming this is a param from join / create form.
    @user_group.user = current_user
    deposit = @user_group.initial_deposit
    @group = Group.find(params[:group_id])
    if @group.total_shares.zero?
      newshares = deposit * 100
    else
      newshares = deposit / (@group.investment_value / @group.total_shares)
    end
    @group.cash_value += deposit
    @group.total_shares += newshares
    @user_group.user_contribution += deposit
    @user_group.user_share += newshares
    @user_group.user_balance = @group.investment_value * (@user_group.user_share / @group.total_shares)
    @user_group.save
  end

  def update
    @user_group.share += transfer
    @user_group.user_contribution += transfer
  end
end
