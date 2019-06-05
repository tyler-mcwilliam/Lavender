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

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :photo)
  end
end
