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

  def twitter_auth?
    !!self.uid
  end

  def update_by_auth(auth)
    self.twitter_id = auth["user_info"]["nickname"]
    self.uid = auth["uid"]
    self.twitter_icon_url = auth["user_info"]["image"]
    self.twitter_url = auth["user_info"]["urls"]["Twitter"]
    self.token = auth["credentials"]["token"]
    self.secret = auth["credentials"]["secret"]
    self.save!
  end

  def friends_graph
    dg = GRATR::Digraph[]
    construct_friends_graph(dg)
    dg
  end

private
  def construct_friends_graph(dg)
    dg.add_vertex!(self, self.name) unless dg.vertex?(self)

    not_yet_added_friends = friends.reject do |friend|
      dg.vertex?(friend) and dg.edge?(self, friend)
    end

    unless not_yet_added_friends.empty?
      not_yet_added_friends.each do |friend| 
        dg.add_vertex!(friend, friend.name) unless dg.vertex?(friend)
        dg.add_edge!(self, friend)     unless dg.edge?(self, friend)
        friend.send(:construct_friends_graph, dg)
      end
    end
  end

end
