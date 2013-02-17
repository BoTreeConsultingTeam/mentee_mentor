class Education < ActiveRecord::Base
  attr_accessible :degree, :from_date, :school, :study_field, :to_date
  
  belongs_to :profile

  validates :to_date, :timeliness => {:on_or_before => lambda { Date.current }, :type => :date, :allow_nil => true, :allow_blank => true}
  validates :from_date, :timeliness => {:before => :to_date, :type => :date, :allow_nil => true, :allow_blank => true}
end
