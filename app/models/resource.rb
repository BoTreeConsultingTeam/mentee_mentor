class Resource < ActiveRecord::Base
  attr_accessible :content, :resource_type, :user_id

  has_many :user_resources
  has_many :users, :through => :user_resources

  validates_presence_of :content

end
	