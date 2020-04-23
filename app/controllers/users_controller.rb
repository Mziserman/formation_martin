class UsersController < ApplicationController
  before_action :authorize_user!

  def show; end
end
