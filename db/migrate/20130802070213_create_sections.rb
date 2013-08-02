class CreateSections < ActiveRecord::Migration
  def change
    create_table :sections do |t|
      t.string :sequence, :limit => 3
      t.integer :max_enrollment
      t.integer :actual_enrollment
      t.boolean :active
      t.integer :campus_id

      t.timestamps
    end
  end
end
