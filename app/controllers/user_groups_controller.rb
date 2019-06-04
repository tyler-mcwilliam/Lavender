class UserGroupsController < ApplicationController
  def create
    # Currenty using params[:deposit] as a placeholder for user's initial deposit.
    # Assuming this is a param from join / create form.
    @channel = Group.find(params[:group_id])
    @user_group = User_group.new
    if @group.total_shares.zero?
      newshares = params[:deposit] * 100
    else
      newshares = params[:deposit] / (@group.investment_value / @group.total_shares)
    end
    @group.cash_value += params[:deposit]
    @group.total_shares += newshares
    @user_group.user_contribution += params[:deposit]
    @user_group.user_share += newshares
    @user_group.user_balance = @group.investment_value * (@user_group.user_share / @group.total_shares)
    @user_group.save
  end

  def update
   # usergroup.share +=
   # usergroup.contirbution +=
  end
end
