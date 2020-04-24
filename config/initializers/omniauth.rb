# frozen_string_literal: true

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, ENV['FACEBOOK_APP_ID'], ENV['FACEBOOK_APP_SECRET'],
           scope: 'email, public_profile',
           info_fields: 'name, first_name, last_name, email, birthday'
end
