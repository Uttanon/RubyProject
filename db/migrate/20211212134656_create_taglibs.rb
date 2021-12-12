class CreateTaglibs < ActiveRecord::Migration[6.1]
  def change
    create_table :taglibs do |t|
      t.string :tag_name

      t.timestamps
    end
  end
end
