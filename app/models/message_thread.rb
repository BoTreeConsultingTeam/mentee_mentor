class MessageThread < ActiveRecord::Base
  attr_accessible :starter_id, :title

  belongs_to :starter, class_name: 'User'

  has_many :messages

  validates_presence_of :title

end
