class UserGroupsController < ApplicationController
  def new
    @user_group = UserGroup.new
  end

  def create
    @user_group = UserGroup.new(user_group_params)
    @user_group.user_id = current_user.id
    @group = @user_group.group
    # USERGROUP | set contribution, balance, and share value | user_balance should update dynamically
    @user_group.user_contribution_cents += cents(params[:user_group]['user_contribution'])
    @user_group.user_balance_cents += cents(params[:user_group]['user_contribution'])
      # can test above by comparing to ((@group.portfolio_value_cents/@group.total_shares) * @user_group.user_share)
    # @user_group.user_share = 0
    @user_group.user_share += (cents(params[:user_group]['user_contribution']) / (@group.portfolio_value_cents.to_f / @group.total_shares)).to_i
    # byebug
    # GROUP | update total shares and cash and portfolio value | portfolio value should update dynamically
    @group.total_shares += @user_group.user_share
    @group.cash_value_cents += cents(params[:user_group]['user_contribution'])
    @group.portfolio_value_cents += cents(params[:user_group]['user_contribution'])
    # USER | deduct deposit
    current_user.available_balance_cents -= cents(params[:user_group]['user_contribution'])
    @groups = current_user.groups
    @polls = @user_group.group.polls

    if cents(params[:user_group]['user_contribution']) > current_user.available_balance_cents
      redirect_to dashboard_path
    else
      @user_group.save!
      @group.save!
      current_user.save!
      respond_to do |format|
        format.html { redirect_to dashboard_path }
        format.js
      end
    end
  end

  def update
    @user_group = UserGroup.find(params[:user_group][:user_group_id])
    @user_group.deposits(cents(params[:user_group][:deposit])) unless params[:user_group][:deposit].nil?
    @user_group.withdraw(cents(params[:user_group][:withdrawal])) unless params[:user_group][:withdrawal].nil?
    @user_group.first_deposit(cents(params[:initial_deposit])) unless params[:initial_deposit].nil?
    @group = @user_group.group
    @group.performance << { "date": DateTime.now, "value": @group.portfolio_value_cents }
    @group.save!
  end

  private

  def user_group_params
    params.require(:user_group).permit(:user_id, :group_id, :user_contribution, :user_share)
  end
end
