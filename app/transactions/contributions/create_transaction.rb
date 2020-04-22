# frozen_string_literal: true

class Contributions::CreateTransaction
  include Dry::Transaction(container: Contributions::Container)

  step :save, with: 'contributions.save'
  tee :create_mangopay_payin

  private

  def create_mangopay_payin(input)
    input[:mangopay_payin] = input[:resource].create_mangopay_payin
    Success(input)
  end
end
