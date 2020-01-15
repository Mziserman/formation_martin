# frozen_string_literal: true

class ProjectsController < ApplicationController
  before_action :set_project, only: :show
  before_action :set_projects, only: :index
  before_action :authorize_admin!, only: :show

  def show; end

  def index; end

  private

  def set_project
    @project = Project.find(params[:id])
  end

  def set_projects
    @projects = if current_admin_user
                 Project.all
               else
                 Project.visible_by_users
               end
  end

  def authorize_admin!
    super if @project.draft?
  end
end
