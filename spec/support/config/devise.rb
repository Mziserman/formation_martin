require 'devise'
require_relative '../helpers/devise_controller_helpers'

RSpec.configure do |config|
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include Warden::Test::Helpers, type: :controller
  config.extend DeviseControllerHelpers, type: :controller
end
