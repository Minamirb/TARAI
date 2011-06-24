# -*- coding: utf-8 -*-
require 'spec_helper'

describe User do
  before(:all) do
    setup_data
  end
  after(:all) do 
    delete_all_data
  end
  context "DUMMY" do
    it { @kozaki.should be_valid }
  end
end
