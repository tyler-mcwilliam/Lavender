class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit]
  def index
    @orders = Order.all
  end

  def show
  end

  def create
    @order = Order.new(order_params)
    @poll = @order.poll
    @order.ticker = @poll.ticker
    @order.quantity = @poll.quantity
    @order.buy = @poll.buy
  end

  def update
    @order.save!
  end

  def destroy
    @order.delete
  end
end
