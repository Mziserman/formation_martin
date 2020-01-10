# frozen_string_literal: true

class Project < ApplicationRecord
  acts_as_taggable_on :categories

  validates :name,
            :amount_wanted_in_cents,
            :small_blurb,
            :long_blurb,
            presence: true

  belongs_to :thumbnail, class_name: 'Photo', optional: true
  belongs_to :landscape, class_name: 'Photo', optional: true

  has_many :project_ownerships
  has_many :owners, through: :project_ownerships, source: :user
end
