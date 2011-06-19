class Friendship < ActiveRecord::Base
  belongs_to :friendshiped, :foreign_key => :friend_id, :class_name => "User"
  belongs_to :followershiped, :foreign_key => :user_id, :class_name => "Parent"
end
