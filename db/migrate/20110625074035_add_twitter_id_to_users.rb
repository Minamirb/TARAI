class AddTwitterIdToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :twitter_id, :string
    add_column :users, :uid, :string
  end

  def self.down
    remove_column :users, :twitter_id
    remove_column :users, :uid
  end
end
