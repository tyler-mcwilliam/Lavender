class Poll < ApplicationRecord
  belongs_to :group
  belongs_to :creator
  belongs_to :position
end
