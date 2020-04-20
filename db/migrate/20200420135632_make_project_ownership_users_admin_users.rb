class MakeProjectOwnershipUsersAdminUsers < ActiveRecord::Migration[6.0]
  def change
    remove_column :project_ownerships, :user_id
    add_column :project_ownerships, :admin_user_id, :integer, index: true
  end
end
