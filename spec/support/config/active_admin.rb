require_relative '../helpers/active_admin_controller_helpers'

RSpec.configure do |config|
  config.include ActiveAdminControllerHelpers, type: :controller
end
