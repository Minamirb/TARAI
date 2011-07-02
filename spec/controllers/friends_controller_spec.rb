require 'spec_helper'

describe FriendsController do
  before(:all) do 
    @kozaki = FactoryGirl.create(:user, :name => 'kozaki')
  end
  before do 
    sign_in @kozaki
  end
  after do 
    sign_out @kozaki
  end
  after(:all) do 
    User.delete_all
  end

  describe "GET 'index'" do
    it "should be successful" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'search'" do
    it "should be successful" do
      get 'search'
      response.should be_success
    end
  end

end
