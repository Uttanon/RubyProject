class Taglib < ApplicationRecord
  has_many :itemtags
  has_many :items, :through => :itemtags
end
