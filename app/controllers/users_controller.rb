class UsersController < ApplicationController
  def new
  end

  def show
  end

  def dashboard
    @group = Group.new
    @user_group = UserGroup.new
    @user_groups = current_user.user_groups
    @user = current_user
    # dynamic dashboard variables
    @groups = current_user.groups
  end

  def update
    current_user.available_balance_cents += (params[:user][:deposit].to_f.round(2) * 100).to_i unless params[:user][:deposit].nil? || params[:user][:deposit].to_f < 0
    current_user.available_balance_cents -= (params[:user][:withdrawal].to_f.round(2) * 100).to_i unless params[:user][:withdrawal].nil? || params[:user][:deposit].to_f < 0
    current_user.save!
    redirect_to dashboard_path
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :photo, :photo_cache)
  end
end
