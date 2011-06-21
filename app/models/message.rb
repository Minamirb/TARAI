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

  def reached?
    mid_reached?(to_user)
  end

  def rejected?
    mid_rejected?(to_user)
  end

  def status
    return :reached if reached?
    return :rejected if rejected?
    return :midflow
  end

private
  def mid_reached?(user)
    user_feedback = feedbacks.select('good').where('user_id = ?', user).first
    not user_feedback.nil? and user_feedback.good
  end

  def mid_rejected?(user)
    return false if from_user == user

    user_feedback = feedbacks.select('good').where('user_id = ?', user).first
    if not user_feedback.nil? and user_feedback.bad
      return true
    end

    user.followers.all? { |follower| mid_rejected?(follower) } ? true : false
  end

end
