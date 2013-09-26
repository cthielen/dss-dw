class CourseOffering < ActiveRecord::Base
  attr_accessible :grading, :term_type, :active, :college, :course, :crn, :department, :end_date, :instructor, :start_date, :term

  # department_id may be blank
  validates_presence_of :course_id, :crn, :term_id, :grading_id, :term_type_id, :active, :college_id, :start_date, :end_date

  belongs_to :term
  belongs_to :department
  belongs_to :instructor
  belongs_to :college
  belongs_to :course
  belongs_to :grading, :class_name => "GradingType"
  belongs_to :term_type
  
  has_many :sections
end
