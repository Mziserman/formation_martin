ActiveAdmin.register AdminUser do
  permit_params :id, :email, :password

  index do
    selectable_column
    id_column
    column :email
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :email
      row :current_sign_in_at
      row :sign_in_count
      row :created_at
    end
    active_admin_comments
  end

  filter :email
  filter :current_sign_in_at
  filter :created_at

  form partial: 'form'
end
