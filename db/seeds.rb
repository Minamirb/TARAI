# -*- coding: utf-8 -*-
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)


users = 
  [
   ['小崎つねあき', 'kozaki@gmail.com', '111111'],
   ['山田虎の信',   'yamada@gmail.com', '222222'],
   ['田中よう子',   'tanaka@gmail.com', '333333'],
   ['鈴木哲夫',     'suzuki@gmail.com', '444444'],
   ['深谷じゅん',   'fukaya@gmail.com', '555555']
  ]

friendships = 
  [
   [ 'kozaki' , 'yamada'],
   [ 'kozaki' , 'tanaka'],
   [ 'yamada' , 'suzuki'],
   [ 'tanaka' , 'suzuki'],
   [ 'suzuki' , 'kozaki'],
   [ 'suzuki' , 'fukaya'],
   [ 'fukaya' , 'yamada']
  ]

messages = 
  [
   # reached
   ['fukaya', 'kozaki', '(1)しかがしかられた！', <<BODY
山田さん(2) OK
田中さん(3) NG
鈴木さん(4) OK
深谷さん(5) OK
結果、深谷さん(5)に届きました。
BODY
   ],
   # not reached
   ['fukaya', 'kozaki', '(2)ニューヨークで入浴', <<BODY
山田さん(2) OK
田中さん(3) NG
鈴木さん(4) NG
届かないメッセージでした。
BODY
   ],
   # just send
   ['fukaya', 'kozaki', '(3)内股をうっちまったゼ', 
    'まだ誰も評価していないメッセージです。'
   ],
   # not yet 
   ['fukaya', 'kozaki', '(4)島根県に島はねぇ。山はあっても山梨県', <<BODY
山田さん(2) NG
田中さんは未だ評価していません
このメッセージは鈴木さんの手前で止まっています。
BODY
   ]
  ]

feedbacks = 
  [
   [1, 'yamada', true, 'とてもユニークな一言でした。'],
   [1, 'tanaka', false, 'しかせんべいの食べすぎです。'],
   [1, 'suzuki', true, 'ギリギリおっけー。'],
   [1, 'fukaya', true, '基本がだいじ。'],
   [2, 'yamada', true, '若いころを思い出すね。'],
   [2, 'tanaka', false, 'ニューヨーカーはシャワーを浴びるもんだよ。'],
   [2, 'suzuki', false, 'リア充爆発しろ！'],
   [4, 'yamada', false, '2つでは寂しい、もっと多くの都道府県に言及すべき。']
  ]

def email2user(address_base)
  User.where('email LIKE ?', "#{address_base}%").first
end

def num2message(num)
  Message.where('joke LIKE ?', "(#{num})%").first
end

User.delete_all
users.each do |name, email, pass| 
  User.create(:email => email, :password => pass, :password_confimation => pass) do |u|
    u.name = name
    u.save
  end
end

Message.delete_all
messages.each do |to, from, joke, body|
  Message.create(:to_user_id => email2user(to).id, :from_user_id => email2user(from).id, 
                 :joke => joke, :body => body)
end

Friendship.delete_all
friendships.each do |user, friend|
  Friendship.create(:user_id => email2user(user).id, :friend_id => email2user(friend).id)
end

Feedback.delete_all
feedbacks.each do |num, user, good, comment|
  Feedback.create(:message_id => num2message(num).id, :user_id => email2user(user).id, :good => good,
                  :comment => comment)
end

twitter_info = 
  [
   ['kozaki', 
    { :twitter_id => 'kozaki_tarai', 
      :uid => 324621403, 
      :twitter_icon_url => 'http://a0.twimg.com/profile_images/1414689337/kozaki_normal.jpg',
      :twitter_url => 'http://twitter.com/kozaki_tarai',
      :token => '324621403-XMhZ4cuy4TdI5ONwwfQwYpAzowy0xA5BYz48hUhw',
      :secret => 'aRU7818MIkxXzC1OqXUlvJxdUG7pQ2z0LhmsWBWXEHE'
    }],
   ['yamada',
    { :twitter_id => 'yamada_tarai',
      :uid => 324622951,
      :twitter_icon_url => 'http://a0.twimg.com/profile_images/1414693274/yamada_normal.jpg',
      :twitter_url =>  'http://twitter.com/yamada_tarai',
      :token =>  '324622951-LFHaOH38n0ho2JwcpiprLvmoDCqwCgI5hpphsfQB',
      :secret => 'UzQlPpt5P1oNRpIn08sPmD8WqEOZSy4jrgunYa3shzM'
    }],
   ['tanaka', 
    { :twitter_id => 'tanaka_tarai', 
      :uid => 324622459,
      :twitter_icon_url => 'http://a3.twimg.com/profile_images/1414691930/tanaka_normal.jpg',
      :twitter_url => 'http://twitter.com/tanaka_tarai',
      :token => '324622459-pqtdj4oUSTxdEWiHayacNtdY2ROCc3jBuV6U4GZw',
      :secret => 'oPvmemkNYXAG38Qkwgty3LCvwKK6vQhNBL5bwOWGFE'
    }],
   ['suzuki', 
    { :twitter_id => 'suzuki_tarai', 
      :uid => 324623333,
      :twitter_icon_url => 'http://a2.twimg.com/profile_images/1414694388/suzuki_normal.jpg',
      :twitter_url => 'http://twitter.com/suzuki_tarai',
      :token => '324623333-FZgRardFEpkeMfLdd82leOGhWgz3jkKbFLCttRsg',
      :secret => 'EXa6vpQmQg2W5rxwpdEOtsy203FSa51OICyNSBDVg'
    }],
   ['fukaya', 
    { :twitter_id => 'fukaya_tarai', 
      :uid => 324623989,
      :twitter_icon_url => 'http://a0.twimg.com/profile_images/1414686731/fukaya_normal.jpg',
      :twitter_url => 'http://twitter.com/fukaya_tarai',
      :token => '324623989-SYWfOIQ0wEgJpTkqPjUtXv2wERjmgMGV6Stfvj3m',
      :secret => 'Jmhu2g1SJRjrRKFmbgJfJqPZZjcrFpE8dLNWFgNGY'
    }]
  ]

twitter_info.each do |name, params|
  user = User.find_by_email("#{name}@gmail.com")
  user.twitter_id = params[:twitter_id]
  user.uid        = params[:uid]
  user.twitter_icon_url = params[:twitter_icon_url]
  user.twitter_url = params[:twitter_url]
  user.token = params[:token]
  user.secret = params[:secret]
  user.save!
end
