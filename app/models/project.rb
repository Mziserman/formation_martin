# frozen_string_literal: true

class Project < ApplicationRecord
  include ImageUploader::Attachment(:thumbnail)
  include ImageUploader::Attachment(:landscape)

  include AASM
  include ActiveAdminAasm

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
        name_presence?
        small_blurb_presence?
        long_blurb_presence?
        thumbnail_presence?
        landscape_presence?
      ]
    end

    event :finish_publication do
      transitions from: :upcoming, to: :ongoing, guard: %i[
        categories_presence?
        rewards_presence?
      ]
    end

    event :succeed do
      transitions from: :ongoing, to: :success, guard: :completed?
    end

    event :fail do
      transitions from: :ongoing, to: :failure, guard: :not_completed?
    end
  end

  def completion
    total_collected.to_f / amount_wanted
  end

  def available_rewards(amount)
    rewards
      .where('limited = false OR contributions_count < stock')
      .where('threshold <= ?', amount)
  end
end
