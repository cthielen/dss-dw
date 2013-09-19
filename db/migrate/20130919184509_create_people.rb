class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string :first
      t.string :last
      t.string :loginid
      t.string :email
      t.string :phone
      t.string :address
      t.integer :iamId

      t.timestamps
    end
  end
end
