class Feedback < ActiveRecord::Base
  belongs_to :user
  belongs_to :message

  def bad
    !good
  end
end
