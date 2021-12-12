class Bucketlib < ApplicationRecord
  belongs_to :user
  has_many :bucketitems
  has_many :items, :through => :bucketitems
end
