class RenameCamelCaseColumns < ActiveRecord::Migration
  def change
    rename_column :people, :iamId, :iam_id
    rename_column :people, :dFirst, :d_first
    rename_column :people, :dMiddle, :d_middle
    rename_column :people, :dLast, :d_last
    rename_column :people, :oFirst, :o_first
    rename_column :people, :oMiddle, :o_middle
    rename_column :people, :oLast, :o_last
    rename_column :people, :isFaculty, :is_faculty
    rename_column :people, :isStaff, :is_staff
    rename_column :people, :isStudent, :is_student
    rename_column :relationships, :isPPS, :is_pps
    rename_column :relationships, :isSIS, :is_sis
    rename_column :titles, :oName, :o_name
    rename_column :titles, :dName, :d_name
  end
end
