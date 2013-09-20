class CreateTitles < ActiveRecord::Migration
  def change
    create_table :titles do |t|
      t.string :code
      t.string :oName
      t.string :dName

      t.timestamps
    end
  end
end
