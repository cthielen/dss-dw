class AddIndiciesToTermDepartmentApiKeyUserApiWhitelistedIpUser < ActiveRecord::Migration
  def change
    add_index :terms, :code
    add_index :departments, :code
    add_index :api_whitelisted_ip_users, :address
    add_index :api_key_users, :name
    add_index :api_key_users, [:name, :secret]
  end
end
