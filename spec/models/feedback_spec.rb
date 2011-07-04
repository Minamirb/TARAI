# -*- coding: utf-8 -*-
require 'spec_helper'

describe Feedback do
  before(:all) do
    setup_data
  end
  after(:all) do 
    delete_all_data
  end
  it "good / bad の評価は必須" do 
    feedback = FactoryGirl.build(:feedback, 
                                 :message => @just_send_message,
                                 :user => @tanaka,
                                 :good => nil)
    feedback.should be_invalid
  end
  context "after_save コールバック" do 
    before do 
      @from = stub_model(User, :id => 1)
      @to = stub_model(User, :id => 2)
      @someone = stub_model(User, :id => 3)
      @message = stub_model(Message, :id => 4, :from_user => @from, :to_user => @to)
      @feedback = FactoryGirl.build(:feedback, :message => @message, :user => @someone,
                                   :good => true, :comment => 'comment')
    end
    it "フィードバックを新規登録すると tweet メソッドが呼ばれる" do 
      @from.stub(:twitter_auth?) { false }
      @feedback.should_receive(:tweet_to).
        with(@from, "#{@feedback.good ? 'GOOD' : 'BAD'} - http://localhost:3000/messages/#{@message.id}/feedbacks")
      @feedback.save
    end
    context "ユーザーが twitter 認証を済ませている場合" do
      before do 
        @from.stub(:twitter_auth?) { true }
        @someone.stub(:twitter_auth?) { true }
      end
      it "Twitter::Client の update メソッドが呼ばれる" do 
        require 'twitter'
        twitter_client = double()
        Twitter::Client.stub(:new).with(any_args) { twitter_client }
        twitter_client.should_receive(:update)
        @feedback.save
      end
    end
  end
end
