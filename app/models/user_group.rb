class UserGroup < ApplicationRecord
  belongs_to :user
  belongs_to :group

  attr_accessor :initial_deposit, :deposit, :withdrawal
end
