class PollsController < ApplicationController
  # before_action :set_group, only: [:show, :edit]
  before_action :set_poll, only: [:show, :edit]

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
    if @poll.group.cash_value < (@poll.quantity * StockQuote::Stock.quote(@poll.ticker).latest_price)
      @poll.save!
    else
      redirect_to root
    end
  end

  def update
    @poll.save!
  end

  def edit
  end

  private

  def set_poll
    @poll = Poll.find(params[:poll_id])
  end

  def poll_params
    params.require(:poll).permit(:description, :quantity, :ticker, :expiration)
  end
end
