# -*- coding: utf-8 -*-
class Feedback < ActiveRecord::Base
  include Rails.application.routes.url_helpers

  belongs_to :user
  belongs_to :message
  validates :good, :inclusion => { :in => [true, false] }

  scope :be_good, where(:good => true)
  scope :be_bad, where(:good => false)

  def bad
    !good
  end
  
  after_save :tweet

  def tweet
    host_info = YAML.load(File.read(Rails.root.join('config', 'host_name.yml')))[Rails.env]
    tweet_to(message.from_user, 
             "#{good ? 'GOOD' : 'BAD'} - #{message_feedbacks_url(message,
                                                                 :host => host_info['host_name'],
                                                                 :port => host_info['port'])}")
  end
  
  private
  def tweet_to(target, message, opts = { })
    if user != target and user.twitter_auth? and target.twitter_auth?
      user_client = Twitter::Client.new(:oauth_token => user.token, :oauth_token_secret => user.secret)
      user_client.update("@#{target.twitter_id} : #{message}", opts)
    end
  end
end
