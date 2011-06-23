class Feedback < ActiveRecord::Base
  belongs_to :user
  belongs_to :message
  validates :good, :inclusion => { :in => [true, false] }

  def bad
    !good
  end
end
