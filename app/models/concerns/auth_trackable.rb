# frozen_string_literal: true

module AuthTrackable
  extend ActiveSupport::Concern

  included do
    has_many :login_activities, as: :user

    def successfull_login_activities
      login_activities.where(success: true)
    end

    def update_successfull_login_activities_count_and_last_connected_at
      update(
        successfull_login_activities_count: successfull_login_activities.count,
        last_connected_at: last_login_activity.created_at
      )
    end

    alias_attribute :sign_in_count, :successfull_login_activities_count

    def last_login_activity
      successfull_login_activities
        .order(created_at: :asc)
        .limit(1).first
    end

    def current_sign_in_at
      last_login_activity&.created_at
    end

    def current_ip
      last_login_activity&.ip
    end
  end
end
