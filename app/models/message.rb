class Message < ActiveRecord::Base
  attr_accessible :content, :datetime, :sender_id, :receiver_id, :message_thread_id
  attr_accessible :acknowledged

  belongs_to :message_thread
  belongs_to :sender, class_name: 'User'
  belongs_to :receiver, class_name: 'User'

  validates_presence_of :content

  before_create :set_datetime

  scope :unread, conditions: { acknowledged: false }

  def unacknowledged?
    self.acknowledged == false
  end

  private

  def set_datetime
    self.datetime = Time.now
  end
end
