class Relationship < ActiveRecord::Base
  attr_accessible :college_id, :department_id, :major_id, :title_id, :isPPS, :isSIS, :person_id
  
  validates :relationship_id, :person_id, :isPPS, :isSIS, presence: true
  
  belongs_to :person
end
