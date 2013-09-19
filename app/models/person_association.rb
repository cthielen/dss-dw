class PersonAssociation < ActiveRecord::Base
  attr_accessible :association_id, :isPPS, :isSIS, :person_id
  
  validates :association_id, :person_id, :isPPS, :isSIS, presence: true
end
