class FriendsController < ApplicationController
  before_filter :authenticate_user!
  def list
    @user = current_user
    @friends = @user.friends
  end

  def search
  end

end
