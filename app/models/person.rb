class Person < ActiveRecord::Base
  attr_accessible :address, :email, :first, :iamId, :last, :loginid, :phone

  has_many :person_relationships
  has_many :relationships, through: :person_relationships

  validates :first, :last, :loginid, :iamId, presence: true
  validates :email, format: { with: /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/, message: "Email is invalid" }
  validates :phone, format: { with: /\(?([0-9]{3})\)?([ .-]?)([0-9]{3})\2([0-9]{4})/, message: "Phone is invalid" }

end
