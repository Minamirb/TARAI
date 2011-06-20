class Message < ActiveRecord::Base
  belongs_to :to_user, :class_name => "User"
  belongs_to :from_user, :class_name => "User"
  has_many :feedbacks

  def not_yet_comment_by(user)
    feedbacks.none? { |feedback| feedback.user == user }
  end
end
