class Store < ApplicationRecord
  has_secure_password :password
  has_one_attached :avatar 
  has_one_attached :cover
  has_many :items 
  validates :name, :presence => true
  validates :password, :presence => true
  has_many :ratings
  has_many :users, :through => :ratings
  validates :name, uniqueness: true
end
