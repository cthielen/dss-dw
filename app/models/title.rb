class Title < ActiveRecord::Base
  attr_accessible :code, :dName, :oName

  validates_presence_of :code, :oName
  validates_uniqueness_of :code
end
