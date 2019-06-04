class OrdersController < ApplicationController
  before_action :set_group, only: [:show, :edit]
  def index
    @orders = Order.all
  end

  def show
  end

  def create
    @order = Order.new(order_params)
  end

  def update
    @order.save!
  end

  def edit
  end

  def order_params
    params.require(:order).permit()
  end
end
