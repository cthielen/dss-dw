class AddAffiliationsToPeople < ActiveRecord::Migration
  def change
    add_column :people, :isFaculty, :boolean
    add_column :people, :isStaff, :Boolean
    add_column :people, :isStudent, :boolean
  end
end
