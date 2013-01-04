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
  has_many :mentors, through: :mentor_connections, source: :mentor

  has_many :mentee_connections, class_name: 'MentorMenteeConnection', foreign_key: 'mentee_id', dependent: :destroy
  has_many :mentees, through: :mentee_connections, source: :mentee

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
