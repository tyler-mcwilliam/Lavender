class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :poll
  # validates :approve, presence: true
  validates_inclusion_of :approve, :in => [true, false]
end
