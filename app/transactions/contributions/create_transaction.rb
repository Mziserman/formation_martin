# frozen_string_literal: true

class Contributions::CreateTransaction
  include Dry::Transaction(container: Contributions::Container)

  step :create, with: 'contributions.create'
  tee :create_mangopay_payin

  private

  def create_mangopay_payin(input)
    input[:mangopay_payin] = input[:resource].create_mangopay_payin
    Success(input)
  end
end
