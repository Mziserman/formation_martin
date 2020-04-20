# frozen_string_literal: true

class Contribution < ApplicationRecord
  validates :user, :project, :amount, presence: true

  belongs_to :user
  belongs_to :project
  belongs_to :reward, optional: true, counter_cache: true

  validate :reward_must_be_available
  validate :amount_must_be_above_threshold

  def reward_must_be_available
    if reward.present? && reward.limited?
      errors.add(:reward, "n'est pas disponible") if reward.stock <= 0
    end
  end

  def amount_must_be_above_threshold
    if reward.present?
      if amount < reward.threshold
        errors.add(
          :reward,
          "n'est pas disponible en dessous de " \
          "#{ApplicationController.helpers.currency_print(reward.threshold)}"
        )
      end
    end
  end

  def mangopay_payin
    if mangopay_payin_id.nil?
      create_mangopay_payin
    else
      fetch_mangopay_payin
    end
  end

  def create_mangopay_payin
    MangoPay::PayIn::Card::Web.create(
      AuthorId: user.mangopay_id || user.mangopay['Id'],
      CreditedWalletId: project.mangopay_wallet_id || project.mangopay_wallet['Id'],
      CardType: 'CB_VISA_MASTERCARD',
      Culture: 'FR',
      DebitedFunds: {
        Currency: 'EUR',
        Amount: amount
      },
      Fees: {
        Currency: 'EUR',
        Amount: 0
      },
      ReturnURL: "#{ENV['ROOT_URL']}/projects/#{project.id}"
    )
  end

  def fetch_mangopay_payin
    MangoPay::PayIn::Card::Web.fetch(mangopay_payin_id)
  end
end
