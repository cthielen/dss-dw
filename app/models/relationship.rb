class Relationship < ActiveRecord::Base
  attr_accessible :college_id, :department_id, :major_id, :title_id, :is_pps, :is_sis, :person_id
  
  validates_presence_of :person_id
  
  belongs_to :person
  belongs_to :college
  belongs_to :department
  belongs_to :major
  belongs_to :title
end
