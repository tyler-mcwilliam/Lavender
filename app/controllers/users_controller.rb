class UsersController < ApplicationController
  def show
  end

  def dashboard
    @group = Group.new
    @user_group = UserGroup.new
    @user_groups = current_user.user_groups
    @groups = current_user.groups
    @user = current_user
  end
end
