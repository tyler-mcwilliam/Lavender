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
      redirect_to group_path(@user_group.group_id)
    else
      render dashboard_path
    end
  end

  def update
    # Currenty using params[:deposit] as a placeholder for user's initial deposit.
    # Assuming this is a param from join / create form.
    @user_group.deposit(params[:user_group][:deposit].to_f.round(2) * 100).to_i) unless params[:user_group][:deposit].nil?
    @user_group.withdraw(params[:user_group][:withdrawal]) unless params[:user_group][:withdrawal].nil?
    @user_group.initial_deposit(params[:initial_deposit]) unless params[:initial_deposit].nil?
    @user_group.save
  end

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
    newshares = deposit / (@group.investment_value_cents / @group.total_shares)
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

  private

  def user_group_params
    params.require(:user_group).permit(:user_id, :group_id, :user_contribution, :user_share)
  end
end
