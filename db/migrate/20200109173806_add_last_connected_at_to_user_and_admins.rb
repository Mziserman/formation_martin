class AddLastConnectedAtToUserAndAdmins < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :last_connected_at, :datetime
    add_column :admin_users, :last_connected_at, :datetime
  end
end
