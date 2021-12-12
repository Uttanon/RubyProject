class CreateStores < ActiveRecord::Migration[6.1]
  def change
    create_table :stores do |t|
      t.string :name
      t.string :password_digest
      t.string :address
      t.date :joindate
      t.float :rating

      t.timestamps
    end
  end
end
