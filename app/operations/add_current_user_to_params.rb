# frozen_string_literal: true

require 'dry/transaction/operation'

class AddCurrentUserToParams
  include Dry::Transaction::Operation

  def call(input)
    input[:params].tap do |params|
      params[:user_id] = input[:current_user].id
    end
    Success(input)
  end
end
