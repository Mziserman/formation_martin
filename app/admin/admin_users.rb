ActiveAdmin.register AdminUser do
  permit_params :id, :email, :password

  index do
    selectable_column
    id_column
    column :email
    column :current_sign_in_at
    column :successfull_login_activities_count
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :email
      row :current_sign_in_at
      row :successfull_login_activities_count
      row :created_at
    end
    active_admin_comments
  end

  filter :email
  filter :successfull_login_activities_count
  filter :created_at

  form partial: 'form'
end
