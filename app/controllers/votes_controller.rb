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
      # @poll.approval += @vote.voting_power if @vote.approve == false
      redirect_to group_path(@group)
    end
  end
end
