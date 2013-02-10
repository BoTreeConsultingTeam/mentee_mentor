class Resource < ActiveRecord::Base
  attr_accessible :content, :resource_type, :user_id

  has_many :userresources
  has_many :users, :through => :userresources

  validates_presence_of :content

end
