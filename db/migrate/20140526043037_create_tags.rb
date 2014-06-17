class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.integer :photo_id 
      t.integer :user_id
      t.integer :originX
      t.integer :originY
      t.integer :width
      t.integer :height
    end
  end
end
