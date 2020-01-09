# frozen_string_literal: true

module AuthTrackable
  extend ActiveSupport::Concern

  included do
    has_many :login_activities, as: :user

    def successfull_login_activities
      login_activities.where(success: true)
    end

    def update_successfull_login_activities_count
      update(
        successfull_login_activities_count: successfull_login_activities.count
      )
    end

    alias_attribute :sign_in_count, :successfull_login_activities_count

    def current_sign_in_at
      successfull_login_activities
        .order(created_at: :asc)
        .limit(1).first&.created_at
    end
  end
end
