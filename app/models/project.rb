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

  has_many :rewards, dependent: :nullify
  has_many :contributions, dependent: :nullify
  has_many :contributors, through: :contributions, source: :user

  has_many :project_ownerships, dependent: :destroy
  has_many :owners, through: :project_ownerships, source: :user

  validates_presence_of :small_blurb,
                        :long_blurb,
                        :thumbnail,
                        :landscape, if: -> { aasm_state == 'upcoming' }

  validates_presence_of :small_blurb,
                        :long_blurb,
                        :thumbnail,
                        :landscape,
                        :categories,
                        :rewards, if: -> { aasm_state == 'ongoing' }

  validates_presence_of :small_blurb,
                        :long_blurb,
                        :thumbnail,
                        :landscape,
                        :categories,
                        :rewards, if: -> { aasm_state == 'succeed' }

  validates_presence_of :small_blurb,
                        :long_blurb,
                        :thumbnail,
                        :landscape,
                        :categories,
                        :rewards, if: -> { aasm_state == 'fail' }

  validate :project_must_be_completed, if: -> { aasm_state == 'succeed' }
  validate :project_must_not_be_completed, if: -> { aasm_state == 'fail' }

  def project_must_be_completed
    if amount_wanted.present? && total_collected < amount_wanted
      errors.add(:amount_wanted, "can't be lower than amount collected")
    end
  end

  def project_must_not_be_completed
    if amount_wanted.present? && total_collected >= amount_wanted
      errors.add(:amount_wanted, "can't be higher than amount collected")
    end
  end

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

  def self.visible_by_users
    where(aasm_state: %i[upcoming ongoing success])
  end

  def completion
    (total_collected.to_f / amount_wanted).round(4)
  end

  def available_rewards
    rewards
      .where('limited = false OR contributions_count < total_stock')
  end

  def threshold_available_rewards(amount)
    available_rewards.where('threshold <= ?', amount)
  end

  def mangopay_wallet
    if mangopay_wallet_id.nil?
      create_mangopay_wallet
    else
      fetch_mangopay_wallet
    end
  end

  def create_mangopay_wallet
    mangopay_wallet = MangoPay::Wallet.create(
      Currency: 'EUR',
      Description: name,
      Owners: [owners.first.mangopay_id || owners.first.mangopay['Id']]
    )

    update(mangopay_wallet_id: mangopay_wallet['Id'])
    mangopay_wallet
  end

  def fetch_mangopay_wallet
    MangoPay::Wallet.fetch(mangopay_wallet_id)
  end
end
