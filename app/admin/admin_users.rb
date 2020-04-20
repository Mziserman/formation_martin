# frozen_string_literal: true

ActiveAdmin.register AdminUser do
  permit_params :email, :password, :first_name, :last_name, :birthdate

  index do
    selectable_column
    id_column
    column :email
    column :last_connected_at
    column :successfull_login_activities_count
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :email
      row :last_connected_at
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
