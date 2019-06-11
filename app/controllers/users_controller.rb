class UsersController < ApplicationController
  def new
  end

  def show
    @user = current_user
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
    current_user.available_balance_cents += cents(params[:user][:deposit]) unless params[:user][:deposit].nil? || params[:user][:deposit].to_f < 0
    current_user.available_balance_cents -= cents(params[:user][:withdrawal]) unless params[:user][:withdrawal].nil? || params[:user][:deposit].to_f < 0
    current_user.total_balance_cents += cents(params[:user][:deposit]) unless params[:user][:deposit].nil? || params[:user][:deposit].to_f < 0
    current_user.total_balance_cents -= cents(params[:user][:withdrawal]) unless params[:user][:withdrawal].nil? || params[:user][:deposit].to_f < 0
    current_user.save!
    if @current_user.save
      respond_to do |format|
        format.html { redirect_to dashboard_path }
        format.js
      end
    else
      redirect_to dashboard_path
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :photo, :photo_cache)
  end
end
