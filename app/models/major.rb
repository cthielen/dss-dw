class Major < ActiveRecord::Base
  attr_accessible :code, :name
  
  validates_presence_of :code, :name
  validates_uniqueness_of :code
end
