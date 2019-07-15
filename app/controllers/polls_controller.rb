class PollsController < ApplicationController
  # before_action :set_group, only: [:show, :edit]
  before_action :set_poll, only: [:show, :edit]
  before_action :set_group, only: [:create]
  before_action :set_stock_quote, only: [:create]

  def index
    @polls = Poll.all
  end

  def show
  end

  def new
    @poll = Poll.new
  end

  def create
    @vote = Vote.new
    @poll = Poll.new(poll_params)
    @poll.ticker.upcase!
    @poll.creator = current_user
    @poll.group = @group
    @poll.price_cents = cents(StockQuote::Stock.quote(@poll.ticker).latest_price)

    respond_to do |format|
      format.js
    end
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

  def set_stock_quote
    StockQuote::Stock.new(api_key: 'pk_5f4dbf25fbd3494cbbd71fe4c33393fe')
  end

  def poll_params
    params.require(:poll).permit(:description, :quantity, :ticker, :expiration, :target_price, :stop_loss_price, :buy, :price, :creator_id, :created_at)
  end
end
