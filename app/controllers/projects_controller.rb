# frozen_string_literal: true

class ProjectsController < ApplicationController
  before_action :set_record, only: :show
  before_action :authorize_admin!, only: :show

  def show; end

  private

  def set_record
    @record = Project.find(params[:id])
  end

  def authorize_admin!
    redirect_to :root if !current_admin_user && @record.draft?
  end
end
