class CreateOrderlines < ActiveRecord::Migration[6.1]
  def change
    create_table :orderlines do |t|
      t.integer :item_id
      t.integer :quantity
      t.integer :soldprice
      t.references :order, null: false, foreign_key: true

      t.timestamps
    end
  end
end
