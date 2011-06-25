class User < ActiveRecord::Base
  # relation to users
  has_many :follower_friend_relationships, :class_name => "Friendship", :foreign_key => :user_id
  has_many :followers, :through => :friend_follower_relationships, :source => :user
  has_many :friend_follower_relationships, :class_name => "Friendship", :foreign_key => :friend_id
  has_many :friends, :through => :follower_friend_relationships, :source => :friend

  has_many :sended_messages, :class_name => "Message", :foreign_key => :from_user_id
  has_many :received_messages, :class_name => "Message", :foreign_key => :to_user_id
  has_many :feedbacks

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me
  
  def friend?(user)
    return true if friends.index{|f| f.id == user.id}
    return false
  end
end
