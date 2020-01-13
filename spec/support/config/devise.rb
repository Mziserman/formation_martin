require 'devise'
require_relative '../helpers/devise_controller_helpers'
require_relative '../helpers/devise_request_helpers'

RSpec.configure do |config|
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include Warden::Test::Helpers, type: :controller
  config.extend DeviseControllerHelpers, type: :controller

  config.include Devise::Test::IntegrationHelpers, type: :request
  config.extend DeviseRequestHelpers, type: :request
end
