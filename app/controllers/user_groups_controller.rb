class UserGroupsController < ApplicationController
  def new
    @user_group = UserGroup.new
  end

  def create
    @user_group = UserGroup.new(user_group_params)
    @user_group.user_contribution += params[:user_group][:initial_deposit].to_f
    @user_group.user_id = current_user.id
    @group = @user_group.group
    @user_group.user_share += params[:user_group][:initial_deposit].to_f / (@group.portfolio_value / @group.total_shares)
    @group.total_shares += @user_group.user_share
    current_user.available_balance -= params[:user_group][:initial_deposit].to_f
    @group.cash_value += params[:user_group][:initial_deposit].to_f
    if @user_group.save!
      @group.save
      current_user.save
      redirect_to dashboard_path
    else
      render dashboard_path
    end
  end

  def update
    @user_group = UserGroup.find(params[:user_group][:user_group_id])
    @user_group.deposits(params[:user_group][:deposit].to_f) unless params[:user_group][:deposit].nil?
    @user_group.withdraw(params[:user_group][:withdrawal].to_f) unless params[:user_group][:withdrawal].nil?
    @user_group.first_deposit(params[:initial_deposit].to_f) unless params[:initial_deposit].nil?
    @user_group.save!
    redirect_to dashboard_path
  end

  private

  def user_group_params
    params.require(:user_group).permit(:user_id, :group_id, :user_contribution, :user_share)
  end
end
