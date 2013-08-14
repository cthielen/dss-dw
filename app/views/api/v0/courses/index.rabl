collection @courses => :courses

attributes :crn, :start_date, :end_date

glue(:course) do
  attributes :title, :number
end

glue(:instructor) {
  attributes :instructor_id
  attribute :first_name => :instructor_first
  attribute :middle_initial => :instructor_middle
  attribute :last_name => :instructor_last
}
glue(:college) { attributes :code => :college_code }

# @department_id will be set if this courses/index call is a nested route within /departments,
# in which case we don't need to display department information (they know it based on their query)
glue(:department) {
  attribute :code => :department_code, :if => lambda { |c| @department_id == nil }
  attribute :description => :department_description, :if => lambda { |c| @department_id == nil }
}
