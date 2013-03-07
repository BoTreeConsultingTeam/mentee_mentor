class UserResource < ActiveRecord::Base
  attr_accessible :resource_id, :user_id

  belongs_to :user
  belongs_to :resource

end
