# -*- coding: utf-8 -*-
require 'spec_helper'

describe "Feedbacks" do
  before do 
    User.delete_all
    Message.delete_all
    Friendship.delete_all
    Feedback.delete_all

    @kozaki = User.create(:email => 'kozaki@gmail.com',
                          :password => '111111', :password_confirm => '111111')
    @tanaka = User.create(:email => 'tanaka@gmail.com',
                          :password => '222222', :password_confirm => '222222')
    @yamada = User.create(:email => 'yamada@gmail.com',
                          :password => '333333', :password_confirm => '333333')
    @message = Message.create(:to_user => @kozaki, :from_user => @yamada, 
                              :joke => 'joke000', :body => 'b')
    Friendship.create(:user => @kozaki, :friend => @tanaka)
    Friendship.create(:user => @tanaka, :friend => @yamada)
  end
  describe "評価待ちメッセージに対して、評価を追加する" do
    before do 
      sign_in @tanaka
      visit mark_messages_path
      click_link '評価する'
    end
    it "評価リンクをクリックすると、新規で評価を登録する画面に遷移する" do
      page.should have_content('評価を登録')
    end
    context "評価を登録すると" do
      before do 
        check 'おもしろい'
        click_button '登録する'
      end
      it "再び評価待ちメッセージ一覧に遷移する" do 
        page.should have_selector('h1', :text => '評価待ちメッセージ一覧')
      end
      it "評価を登録すると、評価待ちのメッセージ一覧から評価済みメッセージが消える" do 
        page.should_not content('joke000')
      end
      it "山田さんに受信済みメッセージとして表示される" do 
        sign_out @tanaka
        sign_in @yamada
        visit received_messages_path
        page.should have_content('joke000')
      end
    end
  end
end
