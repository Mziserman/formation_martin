# frozen_string_literal: true

class ContributionsController < ApplicationController
  before_action :set_record, only: :show
  before_action :authorize_user!, only: %i[new create]
  before_action :set_records, only: :index

  def new
    @record = Contribution.new
  end

  def create
    create_transaction = Contributions::CreateTransaction.new
    create_transaction.call(
      create_params: create_params,
      current_user: current_user,
      current_admin_user: current_admin_user
    ) do |result|
      result.success do |contribution|
      end
      result.failure do |contribution|
      end
    end
  end

  def show; end

  def index; end

  private

  def create_params
    params.require(:contribution).permit(
      :name,
      :amount,
      :reward_id
    )
  end

  def set_record
    @record = Contribution.find(params[:id])
  end

  def set_records; end
end
