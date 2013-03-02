class Message < ActiveRecord::Base
  attr_accessible :content, :datetime, :sender_id, :receiver_id, :message_thread_id
  attr_accessible :acknowledged

  belongs_to :message_thread, touch: true
  belongs_to :sender, class_name: 'User'
  belongs_to :receiver, class_name: 'User'

  validates_presence_of :content

  before_create :set_datetime
  after_create :add_to_message_thread

  scope :unread, conditions: { acknowledged: false }

  def unacknowledged?
    self.acknowledged == false
  end

  private

  def set_datetime
    self.datetime = Time.now
  end

  def add_to_message_thread
    if self.message_thread.nil?
      message_thread_title = "#{self.sender.name}-#{self.receiver.name}_conversation"
      new_message_thread = MessageThread.create(title: message_thread_title, starter_id: self.sender.id)
      self.update_attribute(:message_thread_id, new_message_thread.id)
    end
  end
end
