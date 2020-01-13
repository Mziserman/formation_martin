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
  has_many :donators, through: :contributions, source: :user

  has_many :project_ownerships
  has_many :owners, through: :project_ownerships, source: :user
end
