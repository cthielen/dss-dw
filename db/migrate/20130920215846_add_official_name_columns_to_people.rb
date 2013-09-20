class AddOfficialNameColumnsToPeople < ActiveRecord::Migration
  def change
    add_column :people, :dMiddle, :string
    add_column :people, :oFirst, :string
    add_column :people, :oMiddle, :string
    add_column :people, :oLast, :string
  end
end
