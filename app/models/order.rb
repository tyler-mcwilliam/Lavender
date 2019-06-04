class Order < ApplicationRecord
  belongs_to :poll
  belongs_to :position
end
