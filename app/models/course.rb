class Course < ActiveRecord::Base
  attr_accessible :effective_term_id, :number, :subject_id, :title

  validates_presence_of :title, :number, :effective_term_id, :subject_id

  belongs_to :effective_term, :class_name => "Term"
end
