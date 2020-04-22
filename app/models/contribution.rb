# frozen_string_literal: true

class Contribution < ApplicationRecord
  validates :user, :project, :amount, presence: true

  belongs_to :user
  belongs_to :project
  belongs_to :reward, optional: true

  after_save :update_counter_cache, if: :reward_present?
  after_destroy :update_counter_cache, if: :reward_present?

  def reward_present?
    reward.present?
  end

  def update_counter_cache
    reward.contributions_count = reward.contributions.not_denied.count
    reward.save
  end

  validate :reward_must_be_available
  validate :amount_must_be_above_threshold

  enum state: %i[processing accepted denied]

  scope :not_denied, -> { where.not(state: 2) }

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
