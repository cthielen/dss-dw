class Person < ActiveRecord::Base
  attr_accessible :address, :email, :o_first, :o_middle, :o_last, :d_first, :d_middle, :d_last, :iam_id, :loginid, :phone, :is_faculty, :is_staff, :is_student

  has_many :relationships

  validates :o_first, :o_last, :loginid, :iam_id, presence: true
  # validates :email, format: { with: /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/, message: "Email is invalid" }
  # validates :phone, format: { with: /\(?([0-9]{3})\)?([ .-]?)([0-9]{3})\2([0-9]{4})/, message: "Phone is invalid" }

  # Calculates 'first' for a Person, prefers d_first and falls back to o_first
  def first
    self.d_first ? self.d_first : self.o_first
  end
  # Calculates 'middle' for a Person, prefers d_middle and falls back to o_middle
  def middle
    self.d_middle ? self.d_middle : self.o_middle
  end
  # Calculates 'last' for a Person, prefers d_last and falls back to o_last
  def last
    self.d_last ? self.d_last : self.o_last
  end
end
