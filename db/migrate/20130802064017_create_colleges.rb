class CreateColleges < ActiveRecord::Migration
  def change
    create_table :colleges do |t|
      t.string :code, :limit => 2
      t.string :description, :limit => 30

      t.timestamps
    end
  end
end
