# frozen_string_literal: true

module Contribuable
  extend ActiveSupport::Concern

  included do
    def total_collected
      contributions.accepted.sum(:amount)
    end

    def max_contribution
      contributions.accepted
                   .order(amount: :desc)
                   .limit(1).first
    end

    def min_contribution
      contributions.accepted
                   .order(amount: :asc)
                   .limit(1).first
    end

    def amount_by_users
      contributions.accepted.group(:user).sum(:amount)
    end

    def max_contribution_user_couple
      amount_by_users.max_by { |_user, amount| amount }
    end

    def max_contributor
      max_contribution_user_couple[0]
    end

    def min_contribution_user_couple
      amount_by_users.min_by { |_user, amount| amount }
    end

    def min_contributor
      min_contribution_user_couple[0]
    end

    def amount_contributed_from(user)
      contributions.accepted.where(user_id: user.id).sum(:amount)
    end
  end
end
