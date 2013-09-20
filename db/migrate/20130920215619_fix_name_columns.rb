class FixNameColumns < ActiveRecord::Migration
  def change
    rename_column :people, :first, :dFirst
    rename_column :people, :last, :dLast
  end
end
