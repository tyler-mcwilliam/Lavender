class VotesController < ApplicationController
  def new
    @vote = Vote.new
  end

  def create
    @vote = Vote.new
    @vote.approve = true if params[:commit] == 'yes'
    @vote.approve = false if params[:commit] == 'no'

    @poll = Poll.find(params[:poll_id])
    @group = @poll.group
    @vote.voting_power = current_user.user_groups.find(@group.id).user_share / @group.total_shares
    @vote.poll = @poll
    @vote.user = current_user

    # raise
    if @vote.save

      @poll.approval += @vote.voting_power if @vote.approve == true
      @poll.save
      if true # limit check/need to find out how we are going to register 51%
        @order = Order.new(
          price: @poll.price,
          quantity: @poll.quantity,
          ticker: @poll.ticker,
          buy: @poll.buy,
#           filled: false,
          poll: @poll
        )

        @order.save
      end
      # @poll.approval += @vote.voting_power if @vote.approve == false
      redirect_to group_path(@group)
    end
  end
end


# create_table "orders", force: :cascade do |t|
#     t.float "price"
#     t.integer "quantity"
#     t.string "ticker"
#     t.boolean "buy"
#     t.bigint "poll_id"
#     t.bigint "position_id"
#     t.datetime "created_at", null: false
#     t.datetime "updated_at", null: false
#     t.index ["poll_id"], name: "index_orders_on_poll_id"
#     t.index ["position_id"], name: "index_orders_on_position_id"
#   end

#   create_table "polls", force: :cascade do |t|
#     t.text "description"
#     t.float "approval", default: 0.0
#     t.float "target_price"
#     t.float "stop_loss_price"
#     t.boolean "buy"
#     t.integer "quantity"
#     t.float "price"
#     t.datetime "expiration"
#     t.string "ticker"
#     t.bigint "group_id"
#     t.bigint "creator_id"
#     t.bigint "position_id"
#     t.datetime "created_at", null: false
#     t.datetime "updated_at", null: false
#     t.index ["creator_id"], name: "index_polls_on_creator_id"
#     t.index ["group_id"], name: "index_polls_on_group_id"
#     t.index ["position_id"], name: "index_polls_on_position_id"
#   end
