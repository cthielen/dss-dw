class DropPersonRelationshipTable < ActiveRecord::Migration
  def change
    drop_table :person_relationships
  end
end
