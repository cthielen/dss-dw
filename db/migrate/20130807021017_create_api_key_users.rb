class CreateApiKeyUsers < ActiveRecord::Migration
  def change
    create_table "api_key_users", :force => true do |t|
      t.string   "secret"
      t.datetime "created_at",   :null => false
      t.datetime "updated_at",   :null => false
      t.string   "name"
      t.datetime "logged_in_at"
    end
  end
end
