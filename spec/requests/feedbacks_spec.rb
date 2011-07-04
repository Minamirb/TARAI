# -*- coding: utf-8 -*-
require 'spec_helper'

def sign_in(user, pass = '111111')
  visit root_path
  click_link 'サインイン'
  fill_in 'Eメール', :with => user.email
  fill_in 'Password', :with => pass
  click_button 'Sign in'
end

def sign_out
  visit root_path
  click_link 'サインアウト'
  a = page.driver.browser.switch_to.alert
  a.accept
end

describe "Feedbacks" do
  before(:all) do 
    setup_data
  end
  after(:all) do 
    delete_all_data
  end

  describe "評価待ちメッセージに対して、評価を追加する" do
    before do 
      sign_in @tanaka
      visit mark_messages_path
      find('table tr', :text => 'joke000').click_link '評価する'
    end
    it "評価リンクをクリックすると、新規で評価を登録する画面に遷移する" do
      page.should have_content('評価を登録')
    end
    context "評価を登録すると" do
      before do 
        choose 'おもしろい'
        click_button '登録する'
      end
      it "再び評価待ちメッセージ一覧に遷移する" do 
        page.should have_selector('h1', :text => '評価待ちメッセージ一覧')
      end
      it "評価を登録すると、評価待ちのメッセージ一覧から評価済みメッセージが消える" do 
        page.should_not have_content('joke000')
      end
      it "鈴木さんに評価待ちメッセージとして表示される", :js => true do 
        sign_out
        sign_in @suzuki
        visit mark_messages_path
        page.should have_content('joke000')
      end
    end
  end

  describe "メッセージを送信する" do 
    before do 
      sign_in @kozaki
      visit select_user_path
      find('table tr', :text => @fukaya.name).click_link 'メッセージ作成'
    end
    it "ユーザーを選択すると、メッセージ作成画面に遷移する" do 
      page.should have_selector('h1', :text => 'メッセージ作成')
    end
    context "メッセージを作成する" do 
      before do 
        fill_in 'ジョーク', :with => 'joke111'
        fill_in '本文', :with => '本日はお日柄もよく云々...'
        click_button '送信'
      end
      it "送信済みメッセージ一覧に遷移する" do 
        page.should have_selector('h1', :text => '送信済みメッセージ一覧')
      end
      it "作成したメッセージが表示される" do 
        page.should have_content('joke111')
        page.should have_content('本日はお日柄もよく云々...')
      end
      context "友人の評価待ちメッセージ一覧に表示される", :js => true do 
        before do 
          sign_out
          sign_in @yamada
          visit mark_messages_path
        end
        it { page.should have_content('joke111') }
      end
    end
  end
end
