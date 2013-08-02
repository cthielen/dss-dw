class CreateGradingTypes < ActiveRecord::Migration
  def change
    create_table :grading_types do |t|
      t.string :code, :limit => 1
      t.string :description, :limit => 30

      t.timestamps
    end
  end
end
