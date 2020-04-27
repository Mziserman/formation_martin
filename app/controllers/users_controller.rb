class UsersController < ApplicationController
  before_action :authorize_user!

  def show
    @user_decorator = current_user.decorate
  end
end
