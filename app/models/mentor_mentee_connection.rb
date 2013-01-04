class MentorMenteeConnection < ActiveRecord::Base
  attr_accessible :mentee_id, :mentor_id

  belongs_to :mentor, class_name: "User"
  belongs_to :mentee, class_name: "User"
end
