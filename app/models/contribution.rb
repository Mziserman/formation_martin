# frozen_string_literal: true

class Contribution < ApplicationRecord
  validates :user, :project, :amount_donated_in_cents, presence: true

  belongs_to :user
  belongs_to :project

  def rewards
    project.rewards.where('threshold_in_cents <= ?', amount_donated_in_cents)
  end
end
