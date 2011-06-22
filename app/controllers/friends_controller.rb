class FriendsController < ApplicationController
  before_filter :authenticate_user!
  def list
    @user = current_user
    @friends = @user.friends
  end

  def add
    # find all user not in current_user
    @users = User.where("id <> ?", current_user.id)
  end

  def create
    id = params[:id].to_i
    friend = User.find(id)   
    friendship = Friendship.new
    friendship.user_id = current_user.id
    friendship.friend_id = friend.id
    puts friendship.save!
    redirect_to add_friend_path, :method => :get
  end
  def search
  end

end
