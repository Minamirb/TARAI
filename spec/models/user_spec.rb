# -*- coding: utf-8 -*-
require 'spec_helper'

describe User do
  before(:all) do
    setup_data
    @alone_user = FactoryGirl.create(:user, :name => 'alone')
  end
  after(:all) do 
    @alone_user.destroy
    delete_all_data
  end
  context "友人グラフの作成" do
    describe "kozaki のグラフ" do 
      subject { @kozaki_graph }
      before do 
        @kozaki_graph = @kozaki.friends_graph
      end
      its(:vertices) { should =~ [@kozaki, @tanaka, @yamada, @suzuki, @fukaya] }

      it { should have_edge(@kozaki, @yamada) }
      it { should have_edge(@yamada, @suzuki) }
      it { should have_edge(@suzuki, @fukaya) }
      it { should have_edge(@suzuki, @kozaki) }
      it { should have_edge(@suzuki, @fukaya) }

      it { @kozaki_graph[@suzuki].should == 'suzuki' }
    end
  end
end
