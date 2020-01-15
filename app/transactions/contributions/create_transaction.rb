# frozen_string_literal: true

class Contributions::CreateTransaction
  include Dry::Transaction

  step :add_current_user_to_params
  step :add_project_to_params
  step :create

  private

  def add_current_user_to_params(input)
    input[:params].tap do |params|
      params[:user_id] = input[:current_user].id
    end
    Success(input)
  end

  def add_project_to_params(input)
    input[:params].tap do |params|
      params[:project_id] = input[:project].id
    end
    Success(input)
  end

  def create(input)
    input[:resource] = input[:model].new(input[:params])
    if input[:resource].save
      Success(input)
    else
      Failure(input)
    end
  end
end
