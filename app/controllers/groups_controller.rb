class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :edit, :update]
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
    @group = Group.new
  end

  def show
    @group = Group.find(params[:id])
    # @user_group = @group.user_groups.where(group_id: @group.id).where(user_id: current_user.id)
    # @user_share = @user_group.user_share
    respond_to do |format|
      format.html { render 'show' }
      format.js
    end
  end

  def new
    @group = Group.new
  end

  def create
    @groups = current_user.groups
    @group = Group.new(group_params) # Create the group
    @group.creator = current_user # Assign group to user
    @group.cash_value_cents = cents(params[:group]['initial_deposit']) # Assign initial Cash Value
    @group.portfolio_value_cents = cents(params[:group]['initial_deposit']) # Assign initial portfolio Value
    @group.total_shares = params[:group]['initial_deposit'].to_i * 100
    @group.chatroom = Chatroom.new # Create a chatroom for the group
    @group.performance = {} # Create and empty hash for the group

    today = DateTime.now.to_s # Needs work here
    @group.performance[:today] = @group.portfolio_value # Store initial performance value
    # deduct deposit from user available balance
    current_user.available_balance_cents -= cents(params[:group]['initial_deposit'])
    current_user.save!

    if @group.save
      respond_to do |format|
        format.html { redirect_to dashboard_path }
        format.js
      end
    end
  end

  def edit
  end

  def update
    @group.update(group_params)
    if @group.save
      respond_to do |format|
        format.js
      end
    end
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
      order.poll.group == @group
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
    params.require(:group).permit(:name, :description, :performance, :photo, :photo_cache)
  end
end
