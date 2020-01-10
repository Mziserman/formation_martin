# frozen_string_literal: true

ActiveAdmin.register User do
  permit_params :email,
                :first_name,
                :last_name,
                :password,
                :birthdate
  index do
    selectable_column
    id_column
    column :email
    column 'Prénom', &:first_name
    column 'Nom de famille', &:last_name
    column 'Derniere connection', &:last_connected_at
    column 'IP', &:current_ip
    column 'Nombre de connections', &:sign_in_count
    column 'Date de création', &:created_at
    column 'Date de modification', &:updated_at
    actions
  end

  show do
    attributes_table do
      row :email
      row 'Prénom', &:first_name
      row 'Nom de famille', &:last_name
      row 'Derniere connection', &:last_connected_at
      row 'IP', &:current_ip
      row 'Nombre de connections', &:sign_in_count
      row 'Date de création', &:created_at
      row 'Date de modification', &:updated_at
      row :reset_password_sent_at
      row :reset_password_token
      row :remember_created_at

      row :login_as do
        link_to user.name, login_as_admin_user_path(user), target: '_blank'
      end
    end
    active_admin_comments
  end

  member_action :login_as, method: :get do
    user = User.find(params[:id])
    bypass_sign_in user
    redirect_to root_path
  end

  filter :email
  filter :first_name, label: 'Prénom'
  filter :last_name, label: 'Nom de famille'
  filter :successfull_login_activities_count, label: 'Nombre de connections'
  filter :created_at, label: 'Date de création'
  filter :last_connected_at, label: 'Derniere connection'
end
