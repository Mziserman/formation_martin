require 'webmock/rspec'

WebMock.disable_net_connect!(allow: [], allow_localhost: true)

RSpec.configure do |config|
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end
