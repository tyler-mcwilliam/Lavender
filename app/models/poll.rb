class Poll < ApplicationRecord
  belongs_to :group
  belongs_to :creator, class_name: :User
  belongs_to :position, optional: true
  has_many :orders
  has_many :votes
  validates :description, presence: true
  validates :quantity, presence: true, numericality: true
  validates :ticker, presence: true
  validates :expiration, presence: true
end
