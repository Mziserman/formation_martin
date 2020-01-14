# frozen_string_literal: true

module ProjectFieldChecker
  extend ActiveSupport::Concern

  included do
    def title_presence?
      title.present?
    end

    def small_blurb_presence?
      small_blurb.present?
    end

    def long_blurb_presence?
      long_blurb.present?
    end

    def thumbnail_presence?
      thumbnail.present?
    end

    def landscape_presence?
      landscape_data.present?
    end

    def categories_presence?
      category_list.length.positive?
    end

    def rewards_presence?
      rewards.length.positive?
    end

    def completed?
      completion >= 1.0
    end

    def not_completed?
      !completed?
    end
  end
end
