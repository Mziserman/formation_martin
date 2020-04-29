# frozen_string_literal: true

class Contributions::CreateTransaction
  include Dry::Transaction(container: Contributions::Container)

  step :validate, with: 'contributions.validate'
  step :create_mangopay_payin
  step :set_mangopay_payin_id
  step :save, with: 'contributions.save'

  private

  def create_mangopay_payin(input)
    input = if input[:resource][:payment_method] == 'card'
              pay_by_card(input)
            else
              pay_by_bank_wire(input)
            end

    Success(input)
  end

  def set_mangopay_payin_id(input)
    input[:resource].mangopay_payin_id = input[:mangopay_payin]['Id']

    Success(input)
  end

  def return_url(resource)
    Rails.application.routes.url_helpers.project_contributions_validate_url(resource.project)
  end

  def pay_by_card(input)
    input[:mangopay_payin] = MangoPay::PayIn::Card::Web.create(
      AuthorId: input[:resource].user.mangopay_id,
      CreditedWalletId: input[:resource].project.mangopay_wallet_id,
      CardType: 'CB_VISA_MASTERCARD',
      Culture: 'FR',
      DebitedFunds: {
        Currency: 'EUR',
        Amount: input[:resource].amount
      },
      Fees: {
        Currency: 'EUR',
        Amount: 0
      },
      ReturnURL: return_url(input[:resource])
    )

    input
  end

  def pay_by_bank_wire(input)
    input[:mangopay_payin] = MangoPay::PayIn::BankWire::Direct.create(
      AuthorId: input[:resource].user.mangopay_id,
      CreditedWalletId: input[:resource].project.mangopay_wallet_id,
      Culture: 'FR',
      DeclaredDebitedFunds: {
        Currency: 'EUR',
        Amount: input[:resource].amount
      },
      DeclaredFees: {
        Currency: 'EUR',
        Amount: 0
      }
    )

    input
  end
end
