class Position < ApplicationRecord
  belongs_to :group
  has_many :polls
  has_many :orders, foreign_key: "ticker", class_name: "Order"
  monetize :cost_basis_cents
  monetize :current_price_cents
  monetize :return_cents
end
