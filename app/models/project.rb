# frozen_string_literal: true

class Project < ApplicationRecord
  include ImageUploader::Attachment(:thumbnail)
  include ImageUploader::Attachment(:landscape)

  acts_as_taggable_on :categories

  validates :name,
            :amount_wanted_in_cents,
            presence: true

  has_many :rewards
  has_many :contributions
  has_many :contributors, through: :contributions, source: :user

  has_many :project_ownerships
  has_many :owners, through: :project_ownerships, source: :user

  def total_collected
    contributions.sum(:amount_donated_in_cents)
  end

  def max_contribution
    contributions
      .order(amount_donated_in_cents: :desc)
      .limit(1).first
  end

  def max_contributor
    max_contribution&.user
  end

  def min_contribution
    contributions
      .order(amount_donated_in_cents: :asc)
      .limit(1).first
  end

  def min_contributor
    min_contribution&.user
  end

  def completion
    total_collected.to_f / amount_wanted_in_cents
  end
end
