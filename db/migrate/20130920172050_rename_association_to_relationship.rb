class RenameAssociationToRelationship < ActiveRecord::Migration
  def change
    rename_table :associations, :relationships
  end
end
