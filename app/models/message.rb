class Message < ActiveRecord::Base
  belongs_to :to_user, :class_name => "User"
  belongs_to :from_user, :class_name => "User"
  has_many :feedbacks, :conditions => proc { "user_id <> #{self.from_user.id}" }
  has_many :good_feedbacks, :class_name => "Feedback", :conditions => proc { "good = 't'"}
  has_many :bad_feedbacks, :class_name => "Feedback", :conditions => proc { "good = 'f'" }

  scope :not_yet_comment_by, lambda { |user|
    messages = Message.all.reject do |message|
      Feedback.where(:message_id => message, :user_id => user).exists?
    end
    where(:id => messages)
  }
  scope :to, lambda { |user| where(:to_user_id => user) }

  scope :bad_marked_by, lambda { |user|
    joins('INNER JOIN feedbacks ON messages.id = feedbacks.message_id').
    where(:'feedbacks.user_id' => user, :'feedbacks.good' => false)
  }
  
  scope :exclude_bad_marked_by, lambda { |user|
    messages = Message.all.reject { |message|
      message.bad_feedbacks.exists?
    }
    where(:id => messages)
  }

  def not_yet_comment_by(user)
    feedbacks.where(:user_id => user).empty?
  end

  def already_comment_by(user)
    feedbacks.where(:user_id => user).exists?
  end

  def good_marked_by(user)
    feedbacks.where(:user_id => user).be_good.exists?
  end

  def bad_marked_by(user)
    feedbacks.where(:user_id => user).be_bad.exists?
  end

  def reachable?
    from_user != to_user and
    from_user.friends_graph.vertex?(to_user)
  end

  def unreachable?
    !(reachable?)
  end

  def message_graph
    dg = GRATR::Digraph[]
    construct_message_graph(dg, from_user)
    dg
  end

  def status
    dg = message_graph
    if dg.vertex?(to_user)
      if bad_marked_by(to_user)
        :rejected
      elsif good_marked_by(to_user)
        :reached
      else
        :midflow
      end
    else
      :rejected
    end
  end

  def reached?
    status == :reached
  end

  def rejected?
    status == :rejected
  end

  after_create :praise_by_myself

private
  def praise_by_myself
    Feedback.create(:message => self, :user => self.from_user, :good => true,
                    :comment => 'nice joke')
  end

  def construct_message_graph(dg, user)
    return if bad_marked_by(user)

    dg.add_vertex!(user, user.name) unless dg.vertex?(user)

    not_yet_added_friends = user.friends.reject do |friend|
      !bad_marked_by(friend) and dg.vertex?(friend) and dg.edge?(user, friend)
    end

    unless not_yet_added_friends.empty?
      not_yet_added_friends.each do |friend| 
        dg.add_vertex!(friend, friend.name) unless dg.vertex?(friend)
        dg.add_edge!(user, friend)     unless dg.edge?(user, friend)
        construct_message_graph(dg, friend)
      end
    end
  end
end
