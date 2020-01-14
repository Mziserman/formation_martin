# frozen_string_literal: true

class Project < ApplicationRecord
  include ImageUploader::Attachment(:thumbnail)
  include ImageUploader::Attachment(:landscape)

  include AASM

  include Contribuable
  include ProjectFieldChecker

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
      transitions from: :draft, to: :upcoming, guard: %i[
        title_presence?
        small_blurb_presence?
        long_blurb_presence?
        thumbnail_presence?
        landscape_presence?
      ]
      # Le projet doit avoir, un titre, les deux descriptions, et les 2 images de renseigné.
    end

    event :finish_publication do
      transitions from: :upcoming, to: :ongoing, guard: %i[
        categories_presence?
        rewards_presence?
      ]
      # Le projet doit avoir une catégorie et des rewards
    end

    event :succeed do
      transitions from: :ongoing, to: :success, guard: :completed?
      # Le success ne peut se faire que si le projet depasse les 100% de contributions
    end

    event :fail do
      transitions from: :ongoing, to: :failure, guard: :not_completed?
      # Failure ne peut se faire que si le projet est inferieur 100% de contribution
    end
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
