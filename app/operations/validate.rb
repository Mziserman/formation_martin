# frozen_string_literal: true

require 'dry/transaction/operation'

class Validate
  include Dry::Transaction::Operation

  def call(input)
    if input[:resource].valid?
      Success(input)
    else
      Failure(input)
    end
  end
end
