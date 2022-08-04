class User < ApplicationRecord

  has_secure_password

  validates :username, presence: true
  validates :password, presence: true

  before_save :downcase_username

  def self.auth credentials={}
    User.find_by(username: credentials[:username]&.downcase)
        &.authenticate(credentials[:password])
  end

  private
  def downcase_username
    self.username = self.username.downcase
  end
end
