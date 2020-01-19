# frozen_string_literal: true

require 'dry/transaction/operation'

class Update
  include Dry::Transaction::Operation

  def call(input)
    if input[:resource].update(input[:params])
      Success(input)
    else
      Failure(input)
    end
  end
end
