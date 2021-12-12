class Favlib < ApplicationRecord
  belongs_to :user
  has_many :favitems
  has_many :items, :through => :favitems
end
