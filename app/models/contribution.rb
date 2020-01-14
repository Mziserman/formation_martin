# frozen_string_literal: true

class Contribution < ApplicationRecord
  validates :user, :project, :amount, presence: true

  belongs_to :user
  belongs_to :project
  belongs_to :reward, optional: true, counter_cache: true

  validate :reward_must_be_available

  def reward_must_be_available
    if reward.present? && reward.limited?
      errors.add(:reward, "n'est pas disponible") if reward.stock <= 0
    end
  end
end
