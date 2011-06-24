# -*- coding: utf-8 -*-
FactoryGirl.define do
  factory :user do 
    name "yamada"
    email { "#{name}@gmail.com" }
    password "111111"
    password_confirmation { "#{password}" }
  end
  factory :friendship do 
    user
    association :friend, :factory => :user
  end
  factory :message do 
    association :to_user, :factory => :user
    association :from_user, :factory => :user
    joke 'nice joke'
    body 'hello tarai world'
  end
  factory :feedback do 
    message
    user
    good true
    comment 'nice boat'
  end
end
