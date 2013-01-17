class FollowedFollowing < ActiveRecord::Base
  attr_accessible :followed_id, :following_id

  belongs_to :followed, class_name: 'User'
  belongs_to :following, class_name: 'User'

end
