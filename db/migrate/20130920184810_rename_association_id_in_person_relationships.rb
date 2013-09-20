class RenameAssociationIdInPersonRelationships < ActiveRecord::Migration
  def change
    rename_column :person_relationships, :association_id, :relationship_id
  end
end
