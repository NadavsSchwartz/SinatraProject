class User < ActiveRecord::Base
  validate :password
  has_secure_password
  has_many :flight
end
