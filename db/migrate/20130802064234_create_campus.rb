class CreateCampus < ActiveRecord::Migration
  def change
    create_table :campus do |t|
      t.string :code, :limit => 3
      t.string :description, :limit => 30

      t.timestamps
    end
  end
end
