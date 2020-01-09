ActiveAdmin.register LoginActivity do
  menu false
  # https://github.com/activeadmin/activeadmin/issues/221#issuecomment-10757256
  controller.send(:belongs_to, :admin_user, :user, polymorphic: true)
end
