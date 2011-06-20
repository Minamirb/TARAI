# -*- coding: utf-8 -*-
require 'spec_helper'

describe Friendship do
  it "二重三重での友情は存在しない" do 
    kozaki = User.create!(:name => 'kozaki', :email => 'kozaki@gmail.com',
                          :password => '111111',
                          :password_confimation => '111111')
    yamada = User.create!(:name => 'yamada', :email => 'yamada@gmail.com',
                          :password => '222222',
                          :password_confimation => '222222')
    kozaki.friends << yamada << yamada
    kozaki.friends.should have(1).item
  end
end
