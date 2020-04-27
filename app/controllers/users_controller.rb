# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authorize_user!

  decorates_assigned :user

  def show
    @user = current_user
  end
end
