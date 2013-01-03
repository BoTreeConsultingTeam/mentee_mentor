class Profile < ActiveRecord::Base
  attr_accessible :birthday, :current_location, :first_name, :hometown, :last_name

  belongs_to :user
end
