class Order < ApplicationRecord
  belongs_to :poll
  belongs_to :position
  belongs_to :group, through: :polls
end
