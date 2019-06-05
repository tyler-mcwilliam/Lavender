class Group < ApplicationRecord
  belongs_to :creator, class_name: :User
  has_many :polls, dependent: :destroy
  has_many :positions
  has_many :user_groups
  has_many :users, through: :user_groups
  has_many :orders, through: :polls
  validates :name, presence: true, uniqueness: true, length: { maximum: 20 }
  validates :description, presence: true

  attr_accessor :initial_deposit

  after_create :create_user_group

  def create_user_group
    @user_group = UserGroup.new
    @user_group.group = self
    @user_group.user = self.creator
    @user_group.user_contribution = self.cash_value
    @user_group.user_share = (self.cash_value * 100)
    self.total_shares = (self.cash_value * 100)
    @user_group.user_balance = self.cash_value
    @user_group.save
    self.save
  end
end
