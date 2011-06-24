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
end
