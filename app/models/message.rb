class Message < ActiveRecord::Base
  attr_accessible :content, :date, :sender_id, :receiver_id, :message_thread_id

  belongs_to :message_thread
  belongs_to :sender, class_name: 'User'
  belongs_to :receiver, class_name: 'User'

  validates_presence_of :content

  before_create :set_date

  private

  def set_date
    self.date = Time.now.to_date
  end
end
