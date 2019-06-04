class Position < ApplicationRecord
  belongs_to :group
  has_many :orders
  has_many :polls
end
