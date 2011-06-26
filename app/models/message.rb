class Message < ActiveRecord::Base
  belongs_to :to_user, :class_name => "User"
  belongs_to :from_user, :class_name => "User"
  has_many :feedbacks

  def not_yet_comment_by(user)
    feedbacks.where('user_id = ?', user).empty?
  end

  def already_comment_by(user)
    feedbacks.where('user_id = ?', user).any?
  end

  def good_marked_by(user)
    feedbacks.where('user_id = ?', user).any? { |feedback| feedback.good }
  end

  def bad_marked_by(user)
    feedbacks.where('user_id = ?', user).any? { |feedback| feedback.bad }
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


private

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
