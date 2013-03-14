class Comment < ActiveRecord::Base
  attr_accessible :content, :status_id, :user_id

  belongs_to :user
  belongs_to :status

  validates_presence_of :content

  # Reference: http://stackoverflow.com/questions/2546702/i-have-a-has-many-relationships-and-i-want-to-set-custom-limit-and-offset-as-we
  scope :paginate, lambda { |page, per_page|
    {
       offset: ( ( (page || 1) - 1) * (per_page || 10) ),
       limit: (per_page || 10),
       order: "comments.created_at DESC"
    }
  }
end
