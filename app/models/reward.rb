# frozen_string_literal: true

class Reward < ApplicationRecord
  belongs_to :project
  has_many :contributions
  has_many :users, through: :contributions

  def stock
    return Float::INFINITY unless limited?

    total_stock - contributions_count
  end
end
