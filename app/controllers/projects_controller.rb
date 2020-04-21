# frozen_string_literal: true

class ProjectsController < ApplicationController
  before_action :set_project, only: :show
  before_action :set_projects, only: :index
  before_action :authorize_admin!, only: :show

  def show; end

  def index; end

  private

  def set_project
    @project = if current_admin_user
                 Project.find(params[:id])
               else
                 Project.visible_by_users.find_by(id: params[:id])
               end
  end

  def set_projects
    categories_search = params.dig(:q, :categories)
    @q = if current_admin_user
           Project.includes(:contributions).all.ransack(params[:q]&.except(:categories))
         else
           Project.includes(:contributions).visible_by_users.ransack(params[:q]&.except(:categories))
         end

    @projects = if categories_search.blank?
                  @q.result(distinct: true)
                else
                  @q.result(distinct: true).tagged_with(
                    categories_search
                  )
                end
  end

  def authorize_admin!
    return redirect_to root_path unless @project.present?

    super if @project.draft?
  end
end
