class CreateRatings < ActiveRecord::Migration[6.1]
  def change
    create_table :ratings do |t|
      t.date :comdate
      t.float :ratescore
      t.string :comment
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
