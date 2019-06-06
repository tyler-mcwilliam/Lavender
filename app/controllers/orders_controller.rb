class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit]
  def index
    @orders = Order.all
  end

  def show
  end

  def create
    # if the poll reaches more than 5, then create an order

  end

  def update
    @order.save!
  end

  def destroy
    @order.delete
  end
end
