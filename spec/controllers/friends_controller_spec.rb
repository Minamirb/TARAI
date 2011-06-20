require 'spec_helper'

describe FriendsController do
  before do 
    @kozaki = User.create(:name => 'kozaki', :email => 'kozaki@gmail.com',
                         :password => 'password', :password_confirmation => 'password')
    sign_in @kozaki
  end
  describe "GET 'list'" do
    it "should be successful" do
      get 'list'
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
