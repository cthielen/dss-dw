class CreateApiWhitelistedIpUsers < ActiveRecord::Migration
  def change
    create_table "api_whitelisted_ip_users", :force => true do |t|
      t.string   "address"
      t.datetime "created_at",   :null => false
      t.datetime "updated_at",   :null => false
      t.text     "reason"
      t.datetime "logged_in_at"
    end
  end
end
