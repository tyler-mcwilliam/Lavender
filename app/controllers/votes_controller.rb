class VotesController < ApplicationController

  def new
    @vote = Vote.new
  end

  def create
    @vote = Vote.new
    @poll = Poll.find(params[:poll_id])
    @group = @poll.group
    @vote.voting_power = vote.user.user_groups.find(@group.id).user_share / @group.total_shares
    @vote.poll_id = @poll.id
    @poll.approval += @vote.voting_power if @vote.approve == true
  end
end
