class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.integer :subject_id
      t.string :number, :limit => 5
      t.string :title, :limit => 30
      t.integer :effective_term_id

      t.timestamps
    end
  end
end
