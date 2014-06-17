class AddLoginToUsers < ActiveRecord::Migration
  def change
    add_column :users, :login, :string

    # Set existing user logins to a lowercase version of last_name
    User.reset_column_information
    User.all.each do |user|
      user.login = user.last_name.downcase
      user.save validate: false
    end
  end
end
