class CreateFeedbacks < ActiveRecord::Migration
  def self.up
    create_table :feedbacks do |t|
      t.integer :message_id
      t.integer :user_id
      t.boolean :good
      t.text :comment

      t.timestamps
    end
  end

  def self.down
    drop_table :feedbacks
  end
end
