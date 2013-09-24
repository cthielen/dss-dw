class Title < ActiveRecord::Base
  attr_accessible :code, :d_name, :o_name

  validates_presence_of :code, :o_name
  validates_uniqueness_of :code
end
