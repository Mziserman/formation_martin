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
end
