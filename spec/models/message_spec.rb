# -*- coding: utf-8 -*-
require 'spec_helper'

describe Message do
  context "#not_yet_comment_by" do 
    before do 
      @kozaki = User.create(:email => 'kozaki@gmail.com',
                           :password => '111111', :password_confimation => '111111')
      @fukaya = User.create(:email => 'fukaya@gmail.com',
                           :password => '555555', :password_confimation => '555555')

      @k2f = Message.create(:from_user => @kozaki, :to_user => @fukaya, 
                           :joke => 'a', :body => 'b')
      @tanaka = User.create(:email => 'tanaka@gmail.com', 
                           :password => '222222', :password_confimation => '222222')
    end
    it "まだフィードバックしていないメッセージは true" do 
      @k2f.not_yet_comment_by(@tanaka).should be_true
    end
    it "既にフィードバックを作成したメッセージは false" do 
      Feedback.create(:message => @k2f, :user => @tanaka, :good => true, :comment => 'c')
      @k2f.not_yet_comment_by(@tanaka).should be_false
    end
  end
end
