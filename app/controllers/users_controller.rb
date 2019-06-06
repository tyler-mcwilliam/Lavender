class UsersController < ApplicationController
  def new
  end

  def show
  end

  def dashboard
    @group = Group.new
    @user_group = UserGroup.new
    @user_groups = current_user.user_groups
    @groups = current_user.groups
    @user = current_user
  end

  def update
    current_user.available_balance += params[:user][:deposit].to_f unless params[:user][:deposit].nil?
    current_user.available_balance -= params[:user][:withdrawal].to_f unless params[:user][:withdrawal].nil?
    current_user.save!
    redirect_to dashboard_path
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :photo)
  end
end
