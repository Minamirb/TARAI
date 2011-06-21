# -*- coding: utf-8 -*-
require 'spec_helper'

describe Message do
  before do
    load(Rails.root + 'db' + 'seeds.rb')
    @kozaki = email2user('kozaki')
    @tanaka = email2user('tanaka')
    @yamada = email2user('yamada')
    @suzuki = email2user('suzuki')
    @fukaya = email2user('fukaya')

    @received_message = num2message(1)
    @rejected_message = num2message(2)
    @just_send_message = num2message(3)
    @midflow_message = num2message(4)
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

end
