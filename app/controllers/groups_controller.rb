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
  end

  def create
    @group = Group.new(group_params)
  end

  def update
    @group.save!
  end

  def edit
  end

  private

  def set_group
    @group = Group.find(params[:id])
  end

  def set_polls
    @polls = Poll.select do |poll|
      poll.group_id == @group.id
    end
  end

  def set_orders
    @orders = Order.select do |order|
      order.group_id == @group.id
    end
  end

  def set_positions
    @positions = Position.select do |position|
      position.group_id == @group.id
    end
  end

  def set_users
    @members = User.select do |user|
      user.groups.contains(@group.id)
    end
  end

  def group_params
    params.require(:group).permit(:name, :description)
  end
end
