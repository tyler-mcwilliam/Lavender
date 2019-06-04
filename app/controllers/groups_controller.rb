class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :edit]
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

  def group_params
    params.require(:group).permit(:name, :description)
  end
end
