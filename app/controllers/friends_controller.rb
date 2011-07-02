class FriendsController < ApplicationController
  before_filter :authenticate_user!
  def index
    @users = User.where("id <> ?", current_user.id).page(params[:page])
  end

  def follow
    friend = User.find(params[:id])
    friendship = Friendship.create!(:user => current_user, :friend => friend)
    redirect_to friends_path
  end

  def unfollow
    friendship = current_user.follower_friend_relationships.find_by_friend_id(params[:id])
    friendship.destroy
    redirect_to friends_path
  end
end
