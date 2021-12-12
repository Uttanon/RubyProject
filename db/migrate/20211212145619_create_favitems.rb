class CreateFavitems < ActiveRecord::Migration[6.1]
  def change
    create_table :favitems do |t|
      t.references :item, null: false, foreign_key: true
      t.references :favlib, null: false, foreign_key: true

      t.timestamps
    end
  end
end
