class PersonRelationship < ActiveRecord::Base
  attr_accessible :relationship_id, :isPPS, :isSIS, :person_id
  
  validates :relationship_id, :person_id, :isPPS, :isSIS, presence: true
  
  belongs_to :person
  belongs_to :relationship
end
