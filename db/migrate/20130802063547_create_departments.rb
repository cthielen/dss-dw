class CreateDepartments < ActiveRecord::Migration
  def change
    create_table :departments do |t|
      t.string :code, :limit => 4
      t.string :description, :limit => 30

      t.timestamps
    end
  end
end
