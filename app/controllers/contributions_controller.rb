# frozen_string_literal: true

class ContributionsController < ApplicationController
  before_action :set_project
  before_action :set_contribution, only: :validate
  before_action :authorize_user!, only: %i[new create]
  before_action :authorize_contribution_user, only: :validate

  def new
    @contribution = Contribution.new
  end

  def create
    resource = Contribution.new(permitted_params)
    resource.user = current_user
    resource.project = @project
    resource.amount = permitted_params[:amount].to_f * 100

    create_transaction = Contributions::CreateTransaction.new
    create_transaction.call(
      resource: resource
    ) do |result|
      result.success do |output|
        redirect_to output[:mangopay_payin]['TemplateURL']
      end
      result.failure do |output|
        @contribution = output[:resource]
        render :new
      end
    end
  end

  def validate
    @contribution.fetch_and_update_state
    flash = case @contribution.state
            when 'accepted'
              { success: 'Merci pour votre donation !' }
            when 'denied'
              { alert: 'Votre paiement n\'a pas fonctionné' }
            end

    redirect_to project_path(@project), flash: flash
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

  def set_contribution
    @contribution = Contribution.find(params[:contribution_id])
  end

  def authorize_contribution_user!
    redirect_to root_path unless current_user == @contribution.user
  end
end
