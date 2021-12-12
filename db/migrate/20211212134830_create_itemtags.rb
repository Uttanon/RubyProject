class CreateItemtags < ActiveRecord::Migration[6.1]
  def change
    create_table :itemtags do |t|
      t.references :item, null: false, foreign_key: true
      t.references :taglib, null: false, foreign_key: true

      t.timestamps
    end
  end
end
