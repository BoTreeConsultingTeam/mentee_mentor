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

  has_many :mentor_connections, class_name: 'MentorMenteeConnection', foreign_key: 'mentor_id', dependent: :destroy
  has_many :mentors, through: :mentor_connections

  has_many :mentee_connections, class_name: 'MentorMenteeConnection', foreign_key: 'mentee_id', dependent: :destroy
  has_many :mentees, through: :mentee_connections

  has_many :mquests_received, class_name: 'Mquest', foreign_key: 'to_user', dependent: :destroy, source: :receiver
  has_many :mquests_sent, class_name: 'Mquest', foreign_key: 'from_user', dependent: :destroy, source: :sender

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

  def mquest_sent?(as_role, to_user)
    return false if (as_role.nil? or to_user.nil?)

    flag = false
    mquests_sent.where(to_user: to_user.id).each do |mquest|
      if mquest.as_role == as_role
        flag = true
        break
      end
    end
    flag
  end

  def mquest_received?(as_role, from_user)
    return false if (as_role.nil? or from_user.nil?)

    flag = false
    mquests_received.where(from_user: from_user.id).each do |mquest|
      if mquest.as_role == as_role
        flag = true
        break
      end
    end
    flag
  end

end
