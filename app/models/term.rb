class Term < ActiveRecord::Base
  attr_accessible :code, :description

  validates_presence_of :code, :description
  validates_uniqueness_of :code
end
