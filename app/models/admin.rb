class Admin < ApplicationRecord

  has_secure_password

  validates :name, :presence => true
  validates :email, :presence => true,
            :uniqueness => { case_sensitive: false },
            format: { with: URI::MailTo::EMAIL_REGEXP, on: [:create, :save, :update] }
  validates :password_digest, :presence => true, length: {minimum: 8}, on: :create
  validates :username, :presence => true, length: {minimum: 3}, on: :create
end
