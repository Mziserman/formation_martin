# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[first_name last_name birthdate])
  end

  def authorize_admin!
    redirect_to :root unless current_admin_user
  end

  def authorize_user!
    redirect_to :root unless current_user
  end
end
