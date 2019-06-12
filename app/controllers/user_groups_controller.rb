class UserGroupsController < ApplicationController
  def new
    @user_group = UserGroup.new
  end

  def create
    @user_group = UserGroup.new(user_group_params)
    @user_group.user_contribution_cents += cents(params[:user_group][:initial_deposit])
    @user_group.user_id = current_user.id
    @group = @user_group.group
    @user_group.user_share += cents(params[:user_group][:initial_deposit]) / (@group.portfolio_value_cents / @group.total_shares)
    @group.total_shares += @user_group.user_share
    current_user.available_balance_cents -= cents(params[:user_group][:initial_deposit])
    @group.cash_value_cents += cents(params[:user_group][:initial_deposit])
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
    @user_group.deposits(cents(params[:user_group][:deposit])) unless params[:user_group][:deposit].nil?
    @user_group.withdraw(cents(params[:user_group][:withdrawal])) unless params[:user_group][:withdrawal].nil?
    @user_group.first_deposit(cents(params[:initial_deposit])) unless params[:initial_deposit].nil?
    if @user_group.save
      respond_to do |format|
        format.html { redirect_to dashboard_path }
        format.js
      end
    else
      redirect_to dashboard_path
    end

  end

  private

  def user_group_params
    params.require(:user_group).permit(:user_id, :group_id, :user_contribution, :user_share)
  end
end
