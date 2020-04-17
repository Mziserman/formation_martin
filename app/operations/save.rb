# frozen_string_literal: true

require 'dry/transaction/operation'

class Save
  include Dry::Transaction::Operation

  def call(input)
    if input[:resource].save
      Success(input)
    else
      Failure(input)
    end
  end
end
