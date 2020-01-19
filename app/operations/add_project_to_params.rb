# frozen_string_literal: true

require 'dry/transaction/operation'

class AddProjectToParams
  include Dry::Transaction::Operation

  def call(input)
    input[:params].tap do |params|
      params[:project_id] = input[:project].id
    end
    Success(input)
  end
end
