# frozen_string_literal: true

class Project < ApplicationRecord
  acts_as_taggable_on :categories

  validates :name,
            :amount_wanted_in_cents,
            presence: true

  belongs_to :thumbnail, class_name: 'Photo', optional: true
  accepts_nested_attributes_for :thumbnail
  belongs_to :landscape, class_name: 'Photo', optional: true
  accepts_nested_attributes_for :landscape

  has_many :project_ownerships
  has_many :owners, through: :project_ownerships, source: :user
end
