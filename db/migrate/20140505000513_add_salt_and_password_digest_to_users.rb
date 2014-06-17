class AddSaltAndPasswordDigestToUsers < ActiveRecord::Migration
  def change
      add_column :users, :salt, :string
      add_column :users, :password_digest, :string
      
      # Add passwords for each current user, equal to their :login
      User.reset_column_information
      User.all.each do |user|
        user.password = user.login
        user.save validate: false
      end
  end
end
