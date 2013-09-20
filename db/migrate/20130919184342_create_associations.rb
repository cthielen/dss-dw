class CreateAssociations < ActiveRecord::Migration
  def change
    create_table :associations do |t|
      t.integer :major_id
      t.integer :college_id
      t.integer :department_id
      t.integer :title_id

      t.timestamps
    end
  end
end
