class TwitterSessionsController < ApplicationController
  def create
    auth = request.env["omniauth.auth"]

    current_user.twitter_id = auth["user_info"]["nickname"]
    current_user.uid = auth["uid"]
    current_user.twitter_icon_url = auth["user_info"]["image"]
    current_user.twitter_url = auth["user_info"]["urls"]["Twitter"]
    current_user.save!

    redirect_to show_user_registration_path
  end
  def failure
  end
  def destroy
    current_user.twitter_id = nil
    current_user.uid = nil
    current_user.twitter_icon_url = nil
    current_user.Twitter_url = nil
    current_user.save!
    
    redirect_to show_user_registration_path
  end
end
