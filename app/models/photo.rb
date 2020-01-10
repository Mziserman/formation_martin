# frozen_string_literal: true

class Photo < ApplicationRecord
  include ImageUploader::Attachment(:image)

  has_many :as_thumbnail_projects, class_name: 'Project', foreign_key: :thumbnail_id
  has_many :as_landscape_projects, class_name: 'Project', foreign_key: :landscape_id

  def projects
    Project.where(as_thumbnail_project_ids + as_landscape_project_ids)
  end
end
