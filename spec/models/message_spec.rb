# -*- coding: utf-8 -*-
require 'spec_helper'

describe Message do
  before(:all) do
    setup_data
  end
  after(:all) do 
    delete_all_data
  end
  context "#not_yet_comment_by" do 
    it "まだフィードバックしていないメッセージは true" do 
      @just_send_message.not_yet_comment_by(@tanaka).should be_true
    end
    it "既にフィードバックを作成したメッセージは false" do 
      @rejected_message.not_yet_comment_by(@tanaka).should be_false
    end
  end

  context "#already_comment_ty" do 
    it { @just_send_message.already_comment_by(@tanaka).should be_false }
    it { @rejected_message.already_comment_by(@tanaka).should be_true }
  end

  context "#reached? " do 
    it "メッセージが宛先に届いたら true" do 
      @received_message.should be_reached
    end
    it "メッセージが破棄されたら false" do 
      @rejected_message.should_not be_reached
    end
    it "メッセージが送信中でも fase" do 
      @midflow_message.should_not be_reached
    end
  end

  context "#rejected?" do 
    it "メッセージが宛先に届いたら false" do
      @received_message.should_not be_rejected
    end
    it "メッセージが破棄されたら true" do 
      @rejected_message.should be_rejected
    end
    it "メッセージが送信中なら false" do 
      @midflow_message.should_not be_rejected
    end
    it "自分をフォローしている友人 A が互いにフォローしあうフレンドを持っていても判断できる" do 
      kato = FactoryGirl.create(:user, :name => 'kato')
      mori = FactoryGirl.create(:user, :name => 'mori')
      jibe = FactoryGirl.create(:user, :name => 'jibe')
      ito = FactoryGirl.create(:user, :name => 'ito')
      FactoryGirl.create(:friendship, :user => kato, :friend => mori)
      FactoryGirl.create(:friendship, :user => mori, :friend => kato)
      FactoryGirl.create(:friendship, :user => kato, :friend => jibe)
      message = FactoryGirl.create(:message, :from_user => ito, :to_user => jibe)
      expect { message.rejected? }.to_not raise_exception
    end
  end

  context "#reachable?" do 
    before do 
      @alone_user = FactoryGirl.create(:user, :name => 'alon')
    end
    after do 
      @alone_user.destroy
    end
    it "kozaki から fukaya にはメッセージが届く" do 
      message = FactoryGirl.build(:message, :from_user => @kozaki, :to_user => @fukaya)
      message.should be_reachable
    end
    it "kozaki から alone_user にはメッセージが届かない" do 
      message = FactoryGirl.build(:message, :from_user => @kozaki, :to_user => @alone_user)
      message.should be_unreachable
    end
  end

  context "#mssage_graph" do 
    it "作成したばかりのメッセージからは friends_graph と同じものが得られる" do 
      m_graph = @just_send_message.message_graph
      f_graph = @just_send_message.from_user.friends_graph
      m_graph.edges.should == f_graph.edges
      m_graph.vertices.should == m_graph.vertices
    end
    it "yamada さんが NG を付けると、yamada -> suzuki の edge が消える" do 
      m_graph = @midflow_message.message_graph
      f_graph = @midflow_message.from_user.friends_graph
      m_graph.vertices.should =~  f_graph.vertices
      m_graph.should_not have_edge(@yamada, @suzuki)
    end
    it "suzuki さんが NG を付けると fukaya さんにはもうメッセージは届かない" do 
      m_graph = @rejected_message.message_graph
      m_graph.should_not have_vertex(@fukaya)
    end
  end

  context "#good_marked_by" do 
    it "「おもしろい」とコメントしたら true" do 
      @received_message.good_marked_by(@yamada).should be_true
    end
    it "「つまらない」とコメントしたら false" do 
      @received_message.good_marked_by(@tanaka).should be_false
    end
    it "まだコメントしていない場合も false" do 
      @just_send_message.good_marked_by(@yamada).should be_false
    end
  end

  context "after_create callback" do 
    it "メッセージを作成したら、自画自賛する" do 
      expect { 
        Message.create(:from_user => @kozaki, :to_user => @yamada, :joke => 'a', :body => 'b') 
      }.to change { Feedback.count }.by(1)
    end
    it "メッセージを作成したら、良い評価がとりあえず付く" do 
      message = FactoryGirl.create(:message, :from_user => @kozaki, :to_user => @yamada)
#      message.good_marked_by(@kozaki).should be_true
      Feedback.where(:message_id => message, :user_id => @kozaki, :good => true).should be_exist
    end
  end
end
