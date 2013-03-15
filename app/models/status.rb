class Status < ActiveRecord::Base
  attr_accessible :content, :user_id

  belongs_to :user

  has_many :comments, dependent: :destroy, order: "comments.created_at DESC"
  has_many :likes, dependent: :destroy

  def total_likes
    self.likes.size
  end

  def liked_by_user?(user_id)
    return false if user_id.nil?
    self.likes.exists?(user_id: user_id)
  end

end
