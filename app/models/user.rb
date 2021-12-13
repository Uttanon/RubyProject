class User < ApplicationRecord
  has_secure_password :password
  has_one_attached :avatar 
  has_one :bucketlib
  has_one :favlib
  has_many :orders
  has_many :ratings
  has_many :stores, :through => :ratings
  validates :username, uniqueness: true
end
