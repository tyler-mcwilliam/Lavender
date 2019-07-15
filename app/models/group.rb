class Group < ApplicationRecord
  belongs_to :creator, class_name: :User
  has_many :polls, dependent: :destroy
  has_many :positions
  has_many :user_groups
  has_many :users, through: :user_groups
  has_many :orders, through: :polls
  has_one :chatroom
  validates :name, presence: true, uniqueness: true, length: { maximum: 20 }
  validates :description, presence: true
  mount_uploader :photo, PhotoUploader
  serialize :performance
  monetize :portfolio_value_cents
  monetize :cash_value_cents
  monetize :investment_value_cents

  attr_accessor :initial_deposit

  after_create :create_user_group
  before_action :set_stock_quote
  
  def set_stock_quote
    StockQuote::Stock.new(api_key: 'pk_5f4dbf25fbd3494cbbd71fe4c33393fe')
  end

  def create_user_group
    @user_group = UserGroup.new
    @user_group.group = self
    @user_group.user = self.creator
    @user_group.user_contribution = self.cash_value
    @user_group.user_share = self.total_shares
    @user_group.user_balance = self.cash_value
    @user_group.save!
    self.save!
  end
end
