# frozen_string_literal: true

class ProjectOwnership < ApplicationRecord
  belongs_to :admin_user
  belongs_to :project

  validates :admin_user_id, uniqueness: { scope: :project_id }
end
