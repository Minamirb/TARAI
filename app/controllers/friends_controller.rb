class FriendsController < ApplicationController
  before_filter :authenticate_user!
  def list
    puts current_user.friends
  end

  def search
  end

end
