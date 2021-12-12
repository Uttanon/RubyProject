class Itemtag < ApplicationRecord
  belongs_to :item
  belongs_to :taglib
end
