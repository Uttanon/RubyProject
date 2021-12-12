class Store < ApplicationRecord
  has_secure_password :password
  has_one_attached :avatar 
  has_one_attached :cover
  has_many :items 
end
