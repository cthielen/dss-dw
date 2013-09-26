object @person
attributes :id, :iam_id, :first, :middle, :last, :loginid, :email, :phone, :address, :is_faculty, :is_staff, :is_student

child :relationships do |relationship|
	attributes :is_pps, :is_sis
	glue(:major) {
    attributes :code => :major_code, :description => :major_name
  }
	glue(:college) {
    attributes :code => :college_code, :description => :college_name
  }
	glue(:title) {
    attributes :code => :title_code, :d_name => :title
  }
	glue(:department) {
    attributes :code => :dept_code, :description => :dept_name
  }
end
