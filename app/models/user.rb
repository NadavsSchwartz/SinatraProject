class User < ActiveRecord::Base
  has_many :carts
  has_many :flights, through: :carts
  has_secure_password
  validates_presence_of :name, :email
  validates_uniqueness_of :email, presence: { message: 'That email is already associated to another account. Please use another email.' }
end
