class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :edit]
  before_action :set_polls, only: [:show]
  before_action :set_orders, only: [:show]
  before_action :set_positions, only: [:show]
  before_action :set_users, only: [:show]

  def index
    @groups = Group.all
  end

  def show
    # raise
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

  def group_params
    params.require(:group).permit(:name, :description, :title, :body, :photo)
  end
end
