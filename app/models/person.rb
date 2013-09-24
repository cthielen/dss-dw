class Person < ActiveRecord::Base
  attr_accessible :address, :email, :o_first, :o_middle, :o_last, :d_first, :d_middle, :d_last, :iam_id, :loginid, :phone, :is_faculty, :is_staff, :is_student

  has_many :relationships

  validates :o_first, :o_last, :loginid, :iam_id, presence: true
  # validates :email, format: { with: /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/, message: "Email is invalid" }
  # validates :phone, format: { with: /\(?([0-9]{3})\)?([ .-]?)([0-9]{3})\2([0-9]{4})/, message: "Phone is invalid" }

end
