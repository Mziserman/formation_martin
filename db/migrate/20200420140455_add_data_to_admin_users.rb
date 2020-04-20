class AddDataToAdminUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :admin_users, :first_name, :string, null: false
    add_column :admin_users, :last_name, :string, null: false
    add_column :admin_users, :birthdate, :date, null: false
  end
end
