class Section < ActiveRecord::Base
  attr_accessible :active, :actual_enrollment, :campus_id, :max_enrollment, :sequence

  validates_presence_of :campus_id, :sequence, :actual_enrollment, :max_enrollment, :active
  
  belongs_to :campus
  belongs_to :course_offering
end
