class AddStoreToRating < ActiveRecord::Migration[6.1]
  def change
    add_reference :ratings, :store, null: false, foreign_key: true
  end
end
