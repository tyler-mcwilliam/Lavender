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
    @poll.price_cents = cents(StockQuote::Stock.quote(@poll.ticker).latest_price)

    respond_to do |format|
      # format.html { redirect_to dashboard_path }
      format.js
    end


    # sell only if you have a position with the ticker
    # sell <= the number of stocks you have


    # if @poll.save
    #   respond_to do |format|
    #     format.html
    #     format.js
    #   end
    # else
    #   redirect_to dashboard_path
    # end
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

