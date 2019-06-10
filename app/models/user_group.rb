class UserGroup < ApplicationRecord
  belongs_to :user
  belongs_to :group
  monetize :user_contribution_cents
  monetize :user_balance_cents

  attr_accessor :initial_deposit, :deposit, :withdrawal
end
