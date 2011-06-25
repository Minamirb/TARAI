class TwitterSessionsController < ApplicationController
  def create
    auth = request.env["omniauth.auth"]

    # current_user.twitter_id = auth["user_info"]["nickname"]
    # current_user.uid = auth["uid"]
    # current_user.twitter_icon_url = auth["user_info"]["image"]
    # current_user.twitter_url = auth["user_info"]["urls"]["Twitter"]
    # current_user.save!

    current_user.update_by_auth(auth)

    redirect_to show_user_registration_path
  end
  def failure
  end
  def destroy
    current_user.update_by_auth(
     { 
       'uid' => nil, 
       'user_info' => 
       { 'nickname' => nil, 
         'image' => nil,
         'urls' =>
          {
            'Twitter' => nil
          }
       },
       'credentials' => 
       { 
         'token' => nil,
         'secret' => nil
       }
      }
    )
    redirect_to show_user_registration_path
  end
end
