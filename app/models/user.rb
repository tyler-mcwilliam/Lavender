class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :user_groups
  has_many :groups, through: :user_groups
  has_many :votes
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable,
         omniauth_providers: [:google_oauth2]
  validates :first_name, presence: true
  validates :last_name, presence: true
  # validates :birthdate, presence: true
  # validates :address, presence: true
  validates :email, presence: true, uniqueness: true
  attr_accessor :deposit, :withdrawal
  mount_uploader :photo, PhotoUploader

  def self.from_omniauth(auth)
    # Creates a new user only if it doesn't exist
    where(email: auth.info.email).first_or_initialize do |user|
      user.first_name = auth.info.name.split[0]
      user.last_name = auth.info.name.split[1]
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.save
    end
  end

  def vote_for_this_poll(poll)
    the_vote = poll.votes.find { |vote| vote.user == self }

    return the_vote.approve ? 'yes' : 'no'
  end
    
  def edit
    current_user.available_balance += params[:deposit] unless params[:deposit].nil?
    current_user.available_balance -= params[:withdrawal] unless params[:withdrawal].nil?
    current_user.save!

  end

  after_create :set_photo, :set_balance

  def set_photo
    if self.photo.nil?
      @photos = ['monsters/1', 'monsters/2', 'monsters/3', 'monsters/4', 'monsters/5', 'monsters/6', 'monsters/7', 'monsters/8']
      self.photo = @photos.sample
      self.save!
    end
  end

  def set_balance
    self.available_balance = 0
    self.total_balance = 0
    self.save
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :photo)
  end
end
