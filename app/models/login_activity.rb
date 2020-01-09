class LoginActivity < ApplicationRecord
  belongs_to :user, polymorphic: true, optional: true

  after_create :update_user_counter_cache, if: :success?
  after_destroy :update_user_counter_cache, if: :success?

  def update_user_counter_cache
    user.update_successfull_login_activities_count
  end
end
