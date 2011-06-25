# -*- coding: utf-8 -*-
class Feedback < ActiveRecord::Base
  belongs_to :user
  belongs_to :message
  validates :good, :inclusion => { :in => [true, false] }

  def bad
    !good
  end
  
  after_save :tweet

  def tweet
    tweet_to(self.message.from_user, "#{good ? 'GOOD' : 'BAD'} - #{comment} by #{user.name}")
  end

  private
  def tweet_to(user, message)
    if user.twitter_auth?
      Twitter.configure do |config|
        config.consumer_key       = 'dpvGz7YM47mkBAiBE5iOfw'
        config.consumer_secret    = '01suPvpyYnDFMLHNWz8fINGtOb2FrvGWjKUGQLrFb4'
        config.oauth_token        = user.token
        config.oauth_token_secret = user.secret
      end
 
      twitter_client = Twitter::Client.new
      twitter_client.update(message)
    end
  end
end
