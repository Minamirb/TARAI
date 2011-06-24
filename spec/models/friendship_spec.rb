# -*- coding: utf-8 -*-
require 'spec_helper'

describe Friendship do
  it "二重三重での友情は存在しない" do
    kozaki = FactoryGirl.create(:user, :name => 'kozaki')
    yamada = FactoryGirl.create(:user, :name => 'yamada')

    kozaki.friends << yamada << yamada
    kozaki.friends.should have(1).item
  end
end
