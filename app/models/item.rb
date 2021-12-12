class Item < ApplicationRecord
  belongs_to :store
  has_one_attached :pic
  has_many :itemtags
  has_many :taglibs, :through => :itemtags
  has_many :favitems
  has_many :favlibs, :through => :favitems
  has_many :bucketitems
  has_many :bucketlibs, :through => :bucketitems
end
