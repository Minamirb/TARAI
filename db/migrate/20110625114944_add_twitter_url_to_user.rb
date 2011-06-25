class AddTwitterUrlToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :twitter_url, :string
  end

  def self.down
    remove_column :users, :twitter_url
  end
end
