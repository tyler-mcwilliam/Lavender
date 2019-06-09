class PollsController < ApplicationController
  # before_action :set_group, only: [:show, :edit]
  before_action :set_poll, only: [:show, :edit]
  before_action :set_group, only: [:create]

  def index
    @polls = Poll.all
  end

  def show
  end

  def new
    @poll = Poll.new
  end

  def create
    @poll = Poll.new(poll_params)
    @poll.creator = current_user
    @poll.group = @group
    @poll.price = StockQuote::Stock.quote(@poll.ticker).latest_price
    redirect_to group_path(@group) if @poll.price.nil?
    @poll.save! if @poll.buy == true && @poll.group.cash_value > (@poll.quantity * @poll.price)
    @poll.save! if @poll.buy == false # && @poll.group.positions.include?  group has a position with high enough quantity to sell
    redirect_to group_path(@group)
  end

  def update
    @poll.save!
  end

  def edit
  end

  private

  def set_group
    @group = Group.find(params[:group_id])
  end

  def set_poll
    @poll = Poll.find(params[:id])
  end

  def poll_params
    params.require(:poll).permit(:description, :quantity, :ticker, :expiration, :target_price, :stop_loss_price, :buy, :price, :creator_id, :created_at)
  end
end

