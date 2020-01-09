class AddSuccessfullLoginActivitiesCountToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :successfull_login_activities_count, :integer, default: 0, null: false
    add_column :admin_users, :successfull_login_activities_count, :integer, default: 0, null: false
  end
end
