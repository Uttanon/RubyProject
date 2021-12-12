class CreateBucketlibs < ActiveRecord::Migration[6.1]
  def change
    create_table :bucketlibs do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :quantity

      t.timestamps
    end
  end
end
