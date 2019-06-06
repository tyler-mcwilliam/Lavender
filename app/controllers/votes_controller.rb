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
    @vote.poll_id = @poll.id

    @poll.approval += @vote.voting_power if @vote.approve == true
    @vote.save
    @poll.approval += @vote.voting_power if @vote.approve == true
    redirect_to group_path(@group)
  end
end
