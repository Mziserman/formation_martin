# frozen_string_literal: true

class ProjectsController < ApplicationController
  before_action :set_record, only: :show
  before_action :set_records, only: :index
  before_action :authorize_admin!, only: :show

  def show; end

  def index; end

  private

  def set_record
    @record = Project.find(params[:id])
  end

  def set_records
    @records = if current_admin_user
                 Project.all
               else
                 Project.visible_by_users
               end
  end

  def authorize_admin!
    redirect_to :root if !current_admin_user && @record.draft?
  end
end
