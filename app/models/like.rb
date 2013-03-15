class Like < ActiveRecord::Base
  attr_accessible :status_id, :user_id

  belongs_to :user
  belongs_to :status

end
