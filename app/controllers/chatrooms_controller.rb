class ChatroomsController < ApplicationController
  def index
    @chatroom = Chatroom.new
  end

  def new
    @chatroom = Chatroom.new
  end

  def create
    @chatroom = Chatroom.new(chatroom_params)
    respond_to do |format|
      if @chatroom.save
        format.html { redirect_to @chatroom }
        format.json { render :show, status: :created, location: @chatroom }
      else
        format.html { render :new }
        format.json { render json: @chatroom.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
    @chatroom = Chatroom.find(params[:id])
    render json: @chatroom.chats
  end

  private

  def chatroom_params
    params.require(:chatroom).permit(:email, :name)
  end
end
