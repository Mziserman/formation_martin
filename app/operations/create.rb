# frozen_string_literal: true

require 'dry/transaction/operation'

class Create
  include Dry::Transaction::Operation

  def call(input)
    input[:resource] = input[:model].new(input[:params])
    if input[:resource].save
      Success(input)
    else
      Failure(input)
    end
  end
end
