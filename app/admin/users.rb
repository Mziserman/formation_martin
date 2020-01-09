ActiveAdmin.register User do
  permit_params :email,
                :first_name,
                :last_name,
                :birthdate

  # ID
  # Email
  # Nom
  # Prénom
  # Date de création
  # Date de derniere edition
  # Nombre de connexion
  # Derniere connexion
  # Adresse IP

  index do
    selectable_column
    id_column
    column :email
    column :first_name
    column :last_name
    column :current_sign_in_at
    column :last_ip_address
    column :sign_in_count
    column :created_at
    column :updated_at
    actions
  end

  filter :email
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  form do |f|
    f.inputs do
      f.input :email
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end
end
