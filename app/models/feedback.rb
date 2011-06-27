# -*- coding: utf-8 -*-
class Feedback < ActiveRecord::Base
  include Rails.application.routes.url_helpers

  belongs_to :user
  belongs_to :message
  validates :good, :inclusion => { :in => [true, false] }

  def bad
    !good
  end
  
  after_save :tweet

  def tweet
    tweet_to(message.from_user, "#{good ? 'GOOD' : 'BAD'} - http://localhost:3000#{message_feedbacks_path(message)}")
  end
  
  private
  def tweet_to(target, message)
    if user.twitter_auth? and target.twitter_auth?
      Twitter.configure do |config|
        config.consumer_key       = 'dpvGz7YM47mkBAiBE5iOfw'
        config.consumer_secret    = '01suPvpyYnDFMLHNWz8fINGtOb2FrvGWjKUGQLrFb4'
        config.oauth_token        = user.token
        config.oauth_token_secret = user.secret
      end
      
      user_client = Twitter::Client.new
      user_client.update("@#{target.twitter_id} : #{message}")
    end
  end
end
