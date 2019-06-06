class Position < ApplicationRecord
  belongs_to :group
  has_many :polls
  has_many :orders, foreign_key: "ticker", class_name: "Order"
end
