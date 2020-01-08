require 'devise'

RSpec.configure do |config|
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include Warden::Test::Helpers, type: :controller
end
