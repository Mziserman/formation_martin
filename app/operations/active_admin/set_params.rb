# frozen_string_literal: true

require 'dry/transaction/operation'

class ActiveAdmin::SetParams
  include Dry::Transaction::Operation

  def call(input)
    input[:params] = input[:params][input[:param_key]]
    Success(input)
  end
end
