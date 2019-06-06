class Order < ApplicationRecord
  belongs_to :poll
  belongs_to :group
  # belongs_to :position, class_name: "Position"
end
