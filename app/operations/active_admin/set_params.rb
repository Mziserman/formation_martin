# frozen_string_literal: true

require 'dry/transaction/operation'

class ActiveAdmin::SetParams
  include Dry::Transaction::Operation

  def call(input)
    if input[:params].key?(input[:param_key])
      input[:params] = input[:params][input[:param_key]]
    end
    Success(input)
  end
end
