class Group < ApplicationRecord
  belongs_to :creator
  has_many :polls
  has_many :positions
  has_many :users, through: :user_groups
  has_many :orders, through: :polls
  validates :name, presence: true, uniqueness: true, length: { maximum: 20 }
  validates :description, presence: true
end
