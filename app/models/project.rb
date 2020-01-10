# frozen_string_literal: true

class Project < ApplicationRecord
  acts_as_taggable_on :categories

  # validates :name,
  #           :amount_wanted,
  #           :small_blurb,
  #           :long_blurb,
  #           presence: true

  belongs_to :thumbnail, class_name: 'Image', optional: true
  belongs_to :landscape, class_name: 'Image', optional: true
end
