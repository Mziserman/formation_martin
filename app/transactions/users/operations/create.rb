# frozen_string_literal: true

require 'dry/transaction/operation'

class Users::Operations::Create
  include Dry::Transaction::Operation

  def call(input)
    input[:user] = User.new(input[:sign_up_params])
    if input[:user].save
      Success(input[:user])
    else
      Failure(input[:user])
    end
  end
end
