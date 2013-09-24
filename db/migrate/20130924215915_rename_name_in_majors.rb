class RenameNameInMajors < ActiveRecord::Migration
  def change
    rename_column :majors, :name, :description
  end
end
