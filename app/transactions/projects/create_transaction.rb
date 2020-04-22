# frozen_string_literal: true

class Projects::CreateTransaction
  include Dry::Transaction(container: Projects::Container)

  step :save, with: 'projects.save'
  step :create_wallet

  private

  def create_wallet(input)
    input[:mangopay_wallet] = input[:resource].create_mangopay_wallet

    Success(input)
  end
end
