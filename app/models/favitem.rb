class Favitem < ApplicationRecord
  belongs_to :item
  belongs_to :favlib
end
