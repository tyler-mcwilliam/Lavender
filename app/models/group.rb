class Group < ApplicationRecord
  belongs_to :creator, class_name: :User
  has_many :polls, dependent: :destroy
  has_many :positions
  has_many :user_groups
  has_many :users, through: :user_groups
  has_many :orders, through: :polls
  has_one :chatroom
  validates :name, presence: true, uniqueness: true, length: { maximum: 20 }
  validates :description, presence: true
  mount_uploader :photo, PhotoUploader
  serialize :performance
  monetize :portfolio_value_cents
  monetize :cash_value_cents
  monetize :investment_value_cents

  attr_accessor :initial_deposit
end
