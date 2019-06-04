class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :poll
  validates :approve, presence: true
end
