class Poll < ApplicationRecord
  belongs_to :group
  belongs_to :creator, class_name: :User
  belongs_to :position, optional: true
  has_many :orders
  has_many :votes
  validates :description, presence: true
  validates :quantity, presence: true, numericality: true
  validates :ticker, presence: true
  validates :expiration, presence: true
  monetize :target_price_cents, allow_nil: true
  monetize :stop_loss_price_cents, allow_nil: true
  monetize :price_cents

  before_action :set_stock_quote
  
  def set_stock_quote
    StockQuote::Stock.new(api_key: 'pk_5f4dbf25fbd3494cbbd71fe4c33393fe')
  end
  
  # return true or false if poll has votes from current user
  def has_voted_by_current_user(current_user)
    # raise
    self.votes.any? { |vote| vote.user == current_user }
  end
end
