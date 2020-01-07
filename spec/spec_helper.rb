# frozen_string_literal: true

require 'rails_helper'
require 'rspec-rails'

RSpec.configure do |config|
  config.color = true
  config.tty = true
  config.formatter = :documentation

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  Kernel.srand config.seed
end
