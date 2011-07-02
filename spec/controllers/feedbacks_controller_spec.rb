# -*- coding: utf-8 -*-
require 'spec_helper'

describe FeedbacksController do

  before(:all) do
    setup_data
  end
  after(:all) do 
    delete_all_data
  end

  def valid_attributes(message, user)
    { :good => true, :message_id => message.id, :user_id => user.id }
  end
  describe "GET index" do
    it "メッセージに対するフィードバックの一覧が得られる" do
      get :index, :message_id => @rejected_message
      assigns(:feedbacks).should =~ @rejected_feedbacks
    end
    it "自分自信によるフィードバックは表示されない" do 
      
    end
  end

  describe "GET new" do
    it "新たな @feedback が作成される" do
      get :new, :message_id => @just_send_message
      assigns(:feedback).should be_a_new(Feedback)
    end
    it "@feedback はパラメータで渡されたメッセージと関連づけられる" do 
      get :new, :message_id => @just_send_message
      assigns(:feedback).message.should == @just_send_message
    end
  end

  describe "POST create" do
    describe "with valid params" do
      before do 
        User.any_instance.stub(:twitter_auth?).and_return(false)
      end
      it "creates a new Feedback" do
        expect {
          post :create, :message_id => @just_send_message,
               :feedback => valid_attributes(@just_send_message, @tanaka)
        }.to change(Feedback, :count).by(1)
      end

      it "assigns a newly created feedback as @feedback" do
        post :create, :message_id => @just_send_message,
             :feedback => valid_attributes(@just_send_message, @tanaka)
        assigns(:feedback).should be_a(Feedback)
        assigns(:feedback).should be_persisted
      end

      it "評価待ちメッセージ一覧にリダイレクトする" do
        post :create, :message_id => @just_send_message,
             :feedback => valid_attributes(@just_send_message, @tanaka)
        response.should redirect_to(mark_messages_path)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved feedback as @feedback" do
        # Trigger the behavior that occurs when invalid params are submitted
        Feedback.any_instance.stub(:save).and_return(false)
        post :create, :message_id => @just_send_message, :feedback => {}
        assigns(:feedback).should be_a_new(Feedback)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Feedback.any_instance.stub(:save).and_return(false)
        post :create, :message_id => @just_send_message, :feedback => {}
        response.should render_template("new")
      end
    end
  end

end
