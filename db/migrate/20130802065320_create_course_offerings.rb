class CreateCourseOfferings < ActiveRecord::Migration
  def change
    create_table :course_offerings do |t|
      t.string :crn, :limit => 5
      t.boolean :active
      t.integer :term_id
      t.integer :department_id
      t.integer :instructor_id
      t.integer :college_id
      t.integer :course_id
      t.integer :grading_id
      t.integer :term_type_id
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
  end
end
