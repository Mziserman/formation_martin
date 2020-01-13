# frozen_string_literal: true

class Reward < ApplicationRecord
  belongs_to :project
  has_many :contributions
end
