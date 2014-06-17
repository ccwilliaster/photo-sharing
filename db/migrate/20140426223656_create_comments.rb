class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer  :photo_id
      t.integer  :user_id
      t.datetime :date_time
      t.string   :comment # potentially long, use string over text
    end
  end
end
