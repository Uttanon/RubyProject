class User < ApplicationRecord
  has_secure_password :password
  has_one_attached :avatar 
  has_one :bucketlib
  has_many :orders
end
