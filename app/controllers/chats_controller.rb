class ChatsController < ApplicationController
  def index
    @chatrooms = Chatroom.all
  end

  def new
    @chat = Chat.new
  end

  def create
    @chat = Chat.new(chat_params)
    @chat.save!
    redirect_to dashboard_path
  end

  def show
    @chats = Chat.where(chatroom_id: params[:id])
  end

  private

  def chat_params
    params.require(:chat).permit(:message, :name, :chatroom_id, :user_id)
  end
end
