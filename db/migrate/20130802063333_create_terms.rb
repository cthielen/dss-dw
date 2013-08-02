class CreateTerms < ActiveRecord::Migration
  def change
    create_table :terms do |t|
      t.string :code, :limit => 6
      t.string :description, :limit => 30

      t.timestamps
    end
  end
end
