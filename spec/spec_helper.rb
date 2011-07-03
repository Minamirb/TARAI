# -*- coding: utf-8 -*-
require 'rubygems'
require 'spork'

Spork.prefork do
  # Loading more in this block will cause your tests to run faster. However,
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.

  # This file is copied to spec/ when you run 'rails generate rspec:install'
  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'capybara/rspec'


  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

  RSpec.configure do |config|
    # == Mock Framework
    #
    # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
    #
    # config.mock_with :mocha
    # config.mock_with :flexmock
    # config.mock_with :rr
    config.mock_with :rspec

    # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
    config.fixture_path = "#{::Rails.root}/spec/fixtures"

    # If you're not using ActiveRecord, or you'd prefer not to run each of your
    # examples within a transaction, remove the following line or assign false
    # instead of true.
    config.use_transactional_fixtures = true

    # app/ 以下が更新されたらリロード
    ActiveSupport::Dependencies.clear
    ActiveRecord::Base.instantiate_observers

    # devise helper mothods
    config.include Devise::TestHelpers, :type => :controller

    # request spec のためのフィルター
    config.before(:all, :selenium => true) do 
      Capybara.current_driver = :selenium
    end
    config.after(:all, :selenium => true) do 
      Capybara.use_default_driver
    end

  end
end

Spork.each_run do
  # This code will be run each time you run your specs.

  # FactoryGirl の factories をリロード
  FactoryGirl.factories.clear
  FactoryGirl.definition_file_paths.each do |path|
    load "#{path}.rb" if File.exists?("#{path}.rb")

    if File.directory?(path)
      Dir[File.join(path, '*.rb')].each do |file|
        load file
      end
    end
  end

  # routes.rb のリロード
  Tarai::Application.reload_routes!
end

# --- Instructions ---
# Sort the contents of this file into a Spork.prefork and a Spork.each_run
# block.
#
# The Spork.prefork block is run only once when the spork server is started.
# You typically want to place most of your (slow) initializer code in here, in
# particular, require'ing any 3rd-party gems that you don't normally modify
# during development.
#
# The Spork.each_run block is run each time you run your specs.  In case you
# need to load files that tend to change during development, require them here.
# With Rails, your application modules are loaded automatically, so sometimes
# this block can remain empty.
#
# Note: You can modify files loaded *from* the Spork.each_run block without
# restarting the spork server.  However, this file itself will not be reloaded,
# so if you change any of the code inside the each_run block, you still need to
# restart the server.  In general, if you have non-trivial code in this file,
# it's advisable to move it into a separate file so you can easily edit it
# without restarting spork.  (For example, with RSpec, you could move
# non-trivial code into a file spec/support/my_helper.rb, making sure that the
# spec/support/* files are require'd from inside the each_run block.)
#
# Any code that is left outside the two blocks will be run during preforking
# *and* during each_run -- that's probably not what you want.
#
# These instructions should self-destruct in 10 seconds.  If they don't, feel
# free to delete them.

def setup_data
  (@users = ['kozaki', 'tanaka', 'yamada', 'suzuki', 'fukaya']).each do |name|
    eval("@#{name} = FactoryGirl.create(:user, :name => '#{name}')")
  end

  (@friendships = [
                   [ '@kozaki' , '@yamada'], [ '@kozaki' , '@tanaka'],
                   [ '@yamada' , '@suzuki'],
                   [ '@tanaka' , '@suzuki'],
                   [ '@suzuki' , '@kozaki'], [ '@suzuki' , '@fukaya'],
                   [ '@fukaya' , '@yamada']
                  ]).each do |user, friend|
    eval("FactoryGirl.create(:friendship, 
                             :user => #{user}, :friend => #{friend})")
  end

  @received_message = 
    FactoryGirl.create(:message,
                       :to_user => @fukaya, :from_user => @kozaki)
  @received_feedbacks = []
  [ ['@yamada', true], ['@tanaka', false], ['@suzuki', true], ['@fukaya', true] ].
    each do |user, value|
    eval("@received_feedbacks << 
             FactoryGirl.create(:feedback, :message => @received_message,
                                :user => #{user}, :good => #{value})")
  end

  @rejected_message =
    FactoryGirl.create(:message,
                       :to_user => @fukaya, :from_user => @kozaki)
  @rejected_feedbacks = []
  [ ['@yamada', true], ['@tanaka', false], ['@suzuki', false] ].
    each do |user, value|
    eval("@rejected_feedbacks << 
             FactoryGirl.create(:feedback, :message => @rejected_message,
                                :user => #{user}, :good => #{value})")
  end

  @just_send_message = 
    FactoryGirl.create(:message,
                       :to_user => @fukaya, :from_user => @kozaki,
                       :joke => 'joke000')
  @midflow_message =
    FactoryGirl.create(:message,
                       :to_user => @fukaya, :from_user => @kozaki)
  @midflow_feedbacks = []
  @midflow_feedbacks << 
    FactoryGirl.create(:feedback, :message => @midflow_message,
                       :user => @yamada, :good => false)
end

def delete_all_data
  User.delete_all
  Message.delete_all
  Friendship.delete_all
  Feedback.delete_all
end

RSpec::Matchers.define :have_edge do |source, target|
  match do |graph|
    graph.edge?(source, target)
  end
  failure_message_for_should do |graph|
    graph_ar = graph.edges.map { |edge| "#{graph[edge.source]}->#{graph[edge.target]}" }
    "expected that #{graph_ar} has an edge [#{graph[source]}, #{graph[target]}]"
  end
  failure_message_for_should_not do |graph|
    graph_ar = graph.edges.map { |edge| "#{graph[edge.source]}->#{graph[edge.target]}" }
    "expected that #{graph_ar} has not the edge [#{graph[source]}, #{graph[target]}]"
  end
end

RSpec::Matchers.define :have_vertex do |vertex|
  match do |graph|
    graph.vertex?(vertex)
  end
  failure_message_for_should do |graph|
    graph_ar = graph.edges.map { |edge| "#{graph[edge.source]}->#{graph[edge.target]}" }
    "expected that #{graph_ar} has a vertex #{graph[vertex]}"
  end
  failure_message_for_should_not do |graph|
    graph_ar = graph.edges.map { |edge| "#{graph[edge.source]}->#{graph[edge.target]}" }
    "expected that #{graph_ar} has not a vertex #{graph[vertex]}"
  end
end
