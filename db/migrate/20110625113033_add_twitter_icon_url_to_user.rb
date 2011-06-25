class AddTwitterIconUrlToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :twitter_icon_url, :string
  end

  def self.down
    remove_column :users, :twitter_icon_url
  end
end
