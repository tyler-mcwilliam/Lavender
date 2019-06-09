class Chatroom < ApplicationRecord
  belongs_to :group
  has_many :chats

  attr_accessor :message, :user
end
