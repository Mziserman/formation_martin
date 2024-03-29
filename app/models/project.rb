# frozen_string_literal: true

class Project < ApplicationRecord
  include ImageUploader::Attachment(:thumbnail)
  include ImageUploader::Attachment(:landscape)

  acts_as_taggable_on :categories

  validates :name,
            :amount_wanted_in_cents,
            :small_blurb,
            :long_blurb,
            presence: true

  has_many :project_ownerships
  has_many :owners, through: :project_ownerships, source: :user
end
