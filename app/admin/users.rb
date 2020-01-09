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

  # Email
  # Nom
  # Prenom
  # Date de création
  # Derniere connexion
  # Nombre de connexion

  filter :email
  filter :first_name
  filter :last_name
  filter :successfull_login_activities_count
  filter :created_at
  filter :last_connected_at, label: 'By Date Completed', as: :date_range


  # form do |f|
  #   f.inputs do
  #     f.input :email
  #     f.input :password
  #     f.input :password_confirmation
  #   end
  #   f.actions
  # end
end
