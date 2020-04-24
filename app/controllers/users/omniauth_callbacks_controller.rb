# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    @user = User.where(uid: request.env['omniauth.auth']['uid']).first_or_create do |user|
      user_data = request.env['omniauth.auth']['extra']['raw_info']
      user.email = user_data['email']
      user.first_name = user_data['first_name']
      user.last_name = user_data['last_name']
      if user_data.key?('birthday')
        user.birthdate = Date.strptime(user_data['birthday'], '%m/%d/%Y')
      end
    end

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication # this will throw if @user is not activated
      if is_navigational_format?
        set_flash_message(:notice, :success, kind: 'Facebook')
      end
    else
      session['devise.facebook_data'] = request.env['omniauth.auth']
      render 'devise/registrations/new'
    end
  end

  def failure
    redirect_to root_path
  end
end
