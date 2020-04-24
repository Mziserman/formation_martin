ActiveAdmin.register Contribution do

  belongs_to :project

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :user_id, :project_id, :reward_id, :amount, :state, :mangopay_payin_id
  #
  # or
  #
  # permit_params do
  #   permitted = [:user_id, :project_id, :reward_id, :amount, :state, :mangopay_payin_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

end
