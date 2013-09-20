class AddTypeColumnsToRelationship < ActiveRecord::Migration
  def change
    add_column :relationships, :isPPS, :boolean
    add_column :relationships, :isSIS, :boolean
    add_column :relationships, :person_id, :integer
  end
end
