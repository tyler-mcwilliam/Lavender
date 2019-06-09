class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :edit]
  before_action :set_polls, only: [:show]
  before_action :set_orders, only: [:show]
  before_action :set_positions, only: [:show]
  before_action :set_users, only: [:show]
  before_action :set_user_group, only: [:show, :update]

  def index
    @groups = Group.all.reject do |group|
      group.users.include?(current_user)
    end
    @user_group = UserGroup.new
  end

  def show
    respond_to do |format|
      format.html { render 'show' }
      format.js
    end
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    @group.creator = current_user
    @group.cash_value = params[:group]['initial_deposit']
    @group.portfolio_value = params[:group]['initial_deposit']
    # @user_group = UserGroup.new(initial_deposit: params[:group]['initial_deposit'])
    # @user_group.group = @group
    # @user_group.user = current_user
    if @group.save
      redirect_to group_path(@group)
    else
      render :new
    end
  end

  def update
    @group.save!
  end

  def edit
  end

  def initial_deposit
  end

  private

  def set_group
    @group = Group.find(params[:id])
  end

  def set_polls
    @poll = Poll.new
    @polls = Poll.select do |poll|
      poll.group_id == @group.id
    end
  end

  def set_orders
    @orders = Order.select do |order|
      order.group == @group
    end
  end

  def set_positions
    @positions = Position.select do |position|
      position.group_id == @group.id
    end
  end

  def set_users
    @users = User.select do |user|
      user.groups.includes(@group)
    end
  end

  def set_user_group
    @user_group = UserGroup.select do |user_group|
      user_group.group == @group && user_group.user == current_user
    end
    @user_group = @user_group[0]
  end

  def group_params
    params.require(:group).permit(:name, :description)
  end
end
