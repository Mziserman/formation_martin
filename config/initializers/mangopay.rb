# frozen_string_literal: true

require 'mangopay'

MangoPay.configure do |c|
  c.preproduction = true
  c.client_id = ENV.fetch('MANGOPAY_CLIENT_ID')
  c.client_apiKey = ENV.fetch('MANGOPAY_API_KEY')
  # c.log_file = File.join('mypath', 'mangopay.log')
  # c.http_timeout = 10000
end
