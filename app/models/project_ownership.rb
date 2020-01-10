# frozen_string_literal: true

class ProjectOwnership < ApplicationRecord
  belongs_to :user
  belongs_to :project
end
