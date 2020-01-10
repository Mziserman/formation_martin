# frozen_string_literal: true

class LoginActivity < ApplicationRecord
  belongs_to :user, polymorphic: true, optional: true

  after_create :update_user_successfull_login_activities_count_and_last_connected_at, if: :success?
  after_destroy :update_user_successfull_login_activities_count_and_last_connected_at, if: :success?

  def update_user_successfull_login_activities_count_and_last_connected_at
    user.update_successfull_login_activities_count_and_last_connected_at
  end
end
