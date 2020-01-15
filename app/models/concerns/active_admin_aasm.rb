# frozen_string_literal: true

module ActiveAdminAasm
  extend ActiveSupport::Concern

  included do
    # temporary variable used in ActiveAdmin after_save
    attr_accessor :active_admin_requested_event
  end
end
