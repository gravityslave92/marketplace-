class User < ApplicationRecord
  before_create :generate_authentification_token!
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :products, dependent: :destroy

  validates_uniqueness_of :auth_token

  def generate_authentification_token!
    loop do
      self.auth_token = Devise.friendly_token
      break if auth_token.present?
    end
  end

  private

  def token_exists?(token)
    self.class.exists?(auth_token: token)
  end
end
