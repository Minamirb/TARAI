# -*- coding: utf-8 -*-
require 'spec_helper'

describe MessagesController do
  before(:all) do
    setup_data
  end
  after(:all) do 
    delete_all_data
  end

  context "評価待ち一覧" do 
    before do 
    end
    it "自分のフォロワーのメッセージが表示される" do 
      sign_in @yamada
      get 'mark_list'
      assigns(:messages).should include(@just_send_message)
    end
    it "自分のフォロワーが「おもしろい」と評価したメッセージが表示される" do 
      Feedback.create(:message_id => @just_send_message.id, 
                      :user_id => @yamada.id, 
                      :good => true, :comment => '')
      sign_in @suzuki
      get 'mark_list'
      assigns(:messages).should include(@just_send_message)
    end
    it "既に評価済みのメッセージは表示されない" do
      sign_in @yamada
      get 'mark_list'
      assigns(:messages).should_not include(@midflow_message)
    end
    it "自分が送信したメッセージは表示されない" do 
      Friendship.create(:user_id => @fukaya.id, :friend_id => @kozaki.id)
      sign_in @kozaki
      get 'mark_list'
      assigns(:messages).should_not include(@received_message)
    end
  end

  context "受信メッセージ一覧" do 
    it "自分のフォロワーのメッセージが表示される" do 
      m = Message.create(:from_user_id => @kozaki.id,
                         :to_user_id => @yamada.id,
                         :joke => 'a', :body => 'b')
      sign_in @yamada
      get 'received_list'
      assigns(:messages).should include(m)
    end
    it "自分のフォロワーが「おもしろい」と評価したメッセージが表示される" do 
      m = Message.create(:from_user_id => @kozaki.id,
                         :to_user_id => @suzuki.id,
                         :joke => 'a', :body => 'b')
      Feedback.create(:message_id => m.id,
                      :user_id => @tanaka.id,
                      :good => true, :comment => 'a')
      sign_in @suzuki
      get 'received_list'
      assigns(:messages).should include(m)
    end
    it "既に参照済みのメッセージも表示される" do 
      m = Message.create(:from_user_id => @kozaki.id,
                         :to_user_id => @suzuki.id,
                         :joke => 'a', :body => 'b')
      Feedback.create(:message_id => m.id,
                      :user_id => @tanaka.id,
                      :good => true, :comment => 'a')
      Feedback.create(:message_id => m.id,
                      :user_id => @suzuki.id,
                      :good => true, :comment => 'b')
      sign_in @suzuki
      get 'received_list'
      assigns(:messages).should include(m)
    end
    it "自分で「つまらない」と評価したメッセージは表示されない" do 
      m = Message.create(:from_user_id => @kozaki.id,
                         :to_user_id => @suzuki.id,
                         :joke => 'a', :body => 'b')
      Feedback.create(:message_id => m.id,
                      :user_id => @tanaka.id,
                      :good => true, :comment => 'a')
      Feedback.create(:message_id => m.id,
                      :user_id => @suzuki.id,
                      :good => false, :comment => 'b')
      sign_in @suzuki
      get 'received_list'
      assigns(:messages).should_not include(m)
    end
  end
end
