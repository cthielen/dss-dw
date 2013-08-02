class CreateTermTypes < ActiveRecord::Migration
  def change
    create_table :term_types do |t|
      t.string :code, :limit => 3
      t.string :description, :limit => 30

      t.timestamps
    end
  end
end
