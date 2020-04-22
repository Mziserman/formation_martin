# frozen_string_literal: true

class Projects::CreateTransaction
  include Dry::Transaction(container: Projects::Container)

  step :validate, with: 'projects.validate'
  step :create_wallet
  step :set_mangopay_wallet_id
  step :save, with: 'projects.save'

  private

  def create_wallet(input)
    input[:mangopay_wallet] = MangoPay::Wallet.create(
      Currency: 'EUR',
      Description: input[:resource].name,
      Owners: [input[:resource].owners.first.mangopay_id]
    )

    Success(input)
  end

  def set_mangopay_wallet_id(input)
    input[:resource].mangopay_wallet_id = input[:mangopay_wallet]['Id']

    Success(input)
  end
end
