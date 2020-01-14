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

  def amount_donated_by_users
    contributions.group(:user).sum(:amount_donated_in_cents)
  end

  def max_contribution_user_couple
    amount_donated_by_users.max_by { |_, v| v }
  end

  def max_contributor
    max_contribution_user_couple[0]
  end

  def min_contribution_user_couple
    amount_donated_by_users.min_by { |_, v| v }
  end

  def min_contributor
    min_contribution_user_couple[0]
  end

  def min_contribution
    contributions
      .order(amount_donated_in_cents: :asc)
      .limit(1).first
  end

  def amount_contributed_from(user)
    contributions.where(user_id: user.id).sum(:amount_donated_in_cents)
  end

  def completion
    total_collected.to_f / amount_wanted_in_cents
  end
end
