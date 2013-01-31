class Experience < ActiveRecord::Base
  attr_accessible :company, :description, :from_date, :location, :title, :to_date
  
  belongs_to :profile
end
