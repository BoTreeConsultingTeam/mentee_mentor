class Education < ActiveRecord::Base
  attr_accessible :degree, :from_date, :school, :study_field, :to_date
  
  belongs_to :profile

end
