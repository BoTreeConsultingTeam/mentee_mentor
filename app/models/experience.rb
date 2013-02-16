class Experience < ActiveRecord::Base
  attr_accessible :company, :description, :from_date, :location, :title, :to_date
  
  belongs_to :profile
  
  validates :to_date, :timeliness => {:on_or_before => lambda { Date.current }, :type => :date}
  validates :from_date, :timeliness => {:before => :to_date, :type => :date}
end
