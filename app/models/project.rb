# frozen_string_literal: true

class Project < ApplicationRecord
  include ImageUploader::Attachment(:thumbnail)
  include ImageUploader::Attachment(:landscape)

  include AASM

  acts_as_taggable_on :categories

  validates :name,
            :amount_wanted,
            presence: true

  has_many :rewards
  has_many :contributions
  has_many :contributors, through: :contributions, source: :user

  has_many :project_ownerships
  has_many :owners, through: :project_ownerships, source: :user

  aasm do
    state :draft, initial: true
    state :upcoming
    state :ongoing
    state :success
    state :failure

    event :start_publication do
      transitions from: :draft, to: :upcoming
      # Le projet doit avoir, un titre, les deux descriptions, et les 2 images de renseigné.
    end

    event :finish_publication do
      transitions from: :upcoming, to: :ongoing
      # Le projet doit avoir une catégorie et des rewards
    end

    event :succeed do
      transitions from: :ongoing, to: :success
      # Le success ne peut se faire que si le projet depasse les 100% de contributions
    end

    event :fail do
      transitions from: :ongoing, to: :failure
      # Failure ne peut se faire que si le projet est inferieur 100% de contribution
    end
  end

  def total_collected
    contributions.sum(:amount)
  end

  def max_contribution
    contributions
      .order(amount: :desc)
      .limit(1).first
  end

  def min_contribution
    contributions
      .order(amount: :asc)
      .limit(1).first
  end

  def amount_by_users
    contributions.group(:user).sum(:amount)
  end

  def max_contribution_user_couple
    amount_by_users.max_by { |_user, amount| amount }
  end

  def max_contributor
    max_contribution_user_couple[0]
  end

  def min_contribution_user_couple
    amount_by_users.min_by { |_user, amount| amount }
  end

  def min_contributor
    min_contribution_user_couple[0]
  end

  def amount_contributed_from(user)
    contributions.where(user_id: user.id).sum(:amount)
  end

  def completion
    total_collected.to_f / amount_wanted
  end

  def available_rewards(amount = Float::INFINITY)
    rewards
      .where('limited = false OR contributions_count < stock')
      .where('threshold <= ?', amount)
  end
end
