ActiveAdmin.register User do
  permit_params :email,
                :first_name,
                :last_name,
                :birthdate
  index do
    selectable_column
    id_column
    column :email
    column :first_name
    column :last_name
    column :last_connected_at
    column :current_ip
    column :sign_in_count
    column :created_at
    column :updated_at
    actions
  end

  show do
    attributes_table do
      row :email
      row :first_name
      row :last_name
      row :last_connected_at
      row :current_ip
      row :sign_in_count
      row :created_at
      row :updated_at
      row :reset_password_sent_at
      row :reset_password_token
      row :remember_created_at

      row :login_as do
        link_to user.name, login_as_admin_user_path(user), target: '_blank'
      end
    end
    active_admin_comments
  end

  member_action :login_as, :method => :get do
    user = User.find(params[:id])
    bypass_sign_in user
    redirect_to root_path
  end


  filter :email
  filter :first_name
  filter :last_name
  filter :successfull_login_activities_count
  filter :created_at
  filter :last_connected_at, label: 'Derniere connection'
end
