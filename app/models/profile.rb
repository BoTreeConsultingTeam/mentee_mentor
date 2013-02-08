class Profile < ActiveRecord::Base
  attr_accessible :birthday, :current_location, :first_name, :hometown, :last_name

  belongs_to :user
  
  has_one :education, dependent: :destroy
  accepts_nested_attributes_for :education
  attr_accessible :education_attributes
  
  has_one :experience, dependent: :destroy
  accepts_nested_attributes_for :experience
  attr_accessible :experience_attributes
  
end
