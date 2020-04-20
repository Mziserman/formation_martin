# frozen_string_literal: true

class ContributionsController < ApplicationController
  before_action :set_project
  before_action :authorize_user!, only: %i[new create]

  def new
    @contribution = Contribution.new
  end

  def create
    params = permitted_params.tap do |params|
      params[:user_id] = current_user.id
      params[:project_id] = @project.id
      params[:amount] = params[:amount].to_f * 100
    end
    create_transaction = Contributions::CreateTransaction.new
    create_transaction.call(
      params: params,
      model: Contribution
    ) do |result|
      result.success do |output|
        flash[:success] = 'Merci pour votre donation !'
        redirect_to output[:mangopay_payin]['TemplateURL']
      end
      result.failure do |output|
        @contribution = output[:resource]
        render :new
      end
    end
  end

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
end
