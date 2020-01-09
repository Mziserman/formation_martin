module AuthTrackable
  extend ActiveSupport::Concern

  included do
    has_many :login_activities, as: :user

    def sign_in_count
      login_activities.count
    end

    def current_sign_in_at
      login_activities.last&.created_at
    end
  end
end
