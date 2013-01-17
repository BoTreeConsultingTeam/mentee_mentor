class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body

  has_one :profile, dependent: :delete
  accepts_nested_attributes_for :profile
  # To allow mass assignment for association having accepts_nested_attributes_for
  # enabled.
  attr_accessible :profile_attributes

  has_many :message_threads, foreign_key: 'starter_id'
  has_many :messages_received, class_name: 'Message', foreign_key: 'receiver_id'
  has_many :messages_sent, class_name: 'Message', foreign_key: 'sender_id'


  def message_threads_exchanged_with(user_id)
    return [] if user_id.nil?

    messages_from_user = messages_received.where(sender_id: user_id)
    messages_to_user = messages_sent.where(receiver_id: user_id)
    message_thread_ids = (messages_from_user + messages_to_user).collect do |message|
                            message.message_thread.id
                         end
    MessageThread.where(id: message_thread_ids).to_a
  end

  def name
    return self.email if profile.nil?

    first_name = profile.first_name
    last_name = profile.last_name

    if (first_name.present? and last_name.present?)
      [first_name, last_name].join(" ")
    elsif first_name.present?
      first_name
    else
      self.email
    end
  end

end
