# frozen_string_literal: true

class Reward < ApplicationRecord
  belongs_to :project

  has_many :contributions, dependent: :nullify
  has_many :users, through: :contributions
end
