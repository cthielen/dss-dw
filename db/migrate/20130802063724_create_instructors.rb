class CreateInstructors < ActiveRecord::Migration
  def change
    create_table :instructors do |t|
      t.string :instructor_id, :limit => 9
      t.string :last_name, :limit => 60
      t.string :first_name, :limit => 60
      t.string :middle_initial, :limit => 1

      t.timestamps
    end
  end
end
