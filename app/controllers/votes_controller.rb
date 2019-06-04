class VotesController < ApplicationController
  def create
    @vote = Vote.new
  end
end
