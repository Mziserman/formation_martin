# frozen_string_literal: true

class Contributions::CreateTransaction
  include Dry::Transaction

  step :add_current_user_to_params
  step :create

  private

  def add_current_user_to_params
    input[:create_params].tap do |params|
      params[:user_id] = input[:current_user].id
    end
  end

  def create(input)
    input[:contribution] = Contribution.new(input[:create_params])
    if input[:contribution].save
      Success(input[:contribution])
    else
      Failure(input[:contribution])
    end
  end
end
