class Instructor < ActiveRecord::Base
  attr_accessible :first_name, :instructor_id, :last_name, :middle_initial

  validates_presence_of :instructor_id, :first_name, :last_name
  validates_uniqueness_of :instructor_id
end
