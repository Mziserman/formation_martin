# frozen_string_literal: true

class Contribution < ApplicationRecord
  validates :user, :project, :amount_donated_in_cents, presence: true

  belongs_to :user
  belongs_to :project
  belongs_to :reward, optional: true
end
