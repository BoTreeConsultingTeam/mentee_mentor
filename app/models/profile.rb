class Profile < ActiveRecord::Base
  attr_accessible :birthday, :current_location, :first_name, :hometown, :last_name
  attr_accessible :biography, :gender, :interests, :recent_activities

  belongs_to :user

  has_many :educations, dependent: :destroy
  accepts_nested_attributes_for :educations
  attr_accessible :educations_attributes

  has_many :experiences, dependent: :destroy
  accepts_nested_attributes_for :experiences
  attr_accessible :experiences_attributes

end
