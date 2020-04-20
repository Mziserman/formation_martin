class PassMangopayIdToAdminUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :admin_users, :mangopay_id, :string
  end
end
