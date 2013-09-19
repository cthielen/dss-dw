class CreatePersonAssociations < ActiveRecord::Migration
  def change
    create_table :person_associations do |t|
      t.integer :person_id
      t.integer :association_id
      t.boolean :isSIS
      t.boolean :isPPS

      t.timestamps
    end
  end
end
