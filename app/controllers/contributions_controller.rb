# frozen_string_literal: true

class ContributionsController < ApplicationController
  before_action :set_project
  before_action :set_record, only: :show
  before_action :authorize_user!, only: %i[new create]
  before_action :set_records, only: :index

  def new
    @contribution = Contribution.new
  end

  def create
    create_transaction = Contributions::CreateTransaction.new
    create_transaction.call(
      params: permitted_params,
      model: Contribution,
      project: @project,
      current_user: current_user,
      current_admin_user: current_admin_user
    ) do |result|
      result.success do |output|
        flash[:success] = 'Merci pour votre donation !'
        redirect_to project_path(@project)
      end
      result.failure do |output|
        @contribution = output[:resource]
        render :new
      end
    end
  end

  def show; end

  def index; end

  private

  def permitted_params
    params.require(:contribution).permit(
      :name,
      :amount,
      :reward_id,
      :project_id
    )
  end

  def set_project
    @project = Project.find(params[:project_id])
  end

  def set_records; end
end
