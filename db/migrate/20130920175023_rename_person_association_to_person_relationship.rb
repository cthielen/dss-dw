class RenamePersonAssociationToPersonRelationship < ActiveRecord::Migration
  def change
    rename_table :person_associations, :person_relationships
  end
end
