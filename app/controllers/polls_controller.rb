class PollsController < ApplicationController
  before_action :set_group, only: [:show, :edit]
  def index
    @polls = Poll.all
  end

  def show
  end

  def create
    @poll = Poll.new(poll_params)
  end

  def update
    @poll.save!
  end

  def edit
  end

  def poll_params
    params.require(:poll).permit(:description, :quantity, :ticker, :expiration)
  end
end
