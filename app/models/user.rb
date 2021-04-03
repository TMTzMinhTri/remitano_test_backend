# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  authentication_token   :string
#  encrypted_password     :string           default(""), not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  username               :string           default(""), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_username              (username) UNIQUE
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  attr_writer :login

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, authentication_keys: [:login]

  has_many :movies, dependent: :destroy

  #  validations
  validates :username, presence: true, uniqueness: { case_sensitive: false }

  # callback
  before_save :set_authentication_token

  def email_required?
    false
  end

  def email_changed?
    false
  end

  def will_save_change_to_email?
    false
  end

  def login
    @login ||= self.username
  end

  def set_new_authentication_token
    update_columns(authentication_token: generate_authentication_token)
  end

  class << self
    def authorize(params)
      return find_by(authentication_token: params[:access_token]) if params[:access_token]

      account = find_for_database_authentication(params.slice(*authentication_keys))

      return unless account && account.valid_password?(params[:password])
      account
    end

    def authorize!(params)
      user = authorize(params)

      unless user
        raise ApplicationError, "Email or Password is not correct"
      end

      user.set_new_authentication_token if user.authentication_token.blank?
      user
    end
  end

  private

  def set_authentication_token
    self.authentication_token ||= generate_authentication_token
  end

  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless self.class.exists?(authentication_token: token)
    end
  end
end
