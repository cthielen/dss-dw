class Relationship < ActiveRecord::Base
  attr_accessible :college_id, :department_id, :major_id, :title_id, :is_pps, :is_sis, :person_id
  
  validates :person_id, :is_pps, :is_sis, presence: true
  
  belongs_to :person
end
