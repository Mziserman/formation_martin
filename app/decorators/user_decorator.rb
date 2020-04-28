# frozen_string_literal: true

class UserDecorator < ApplicationDecorator
  delegate_all

  def print_amount_for_project(project)
    h.currency_print(amount_contributed_to(project))
  end

  def print_percent_contributed(project)
    h.percent_print(amount_contributed_to(project) / project.total_collected)
  end

  def facture_link_text(contribution)
    "Facture (#{h.currency_print(contribution.amount)})"
  end
end
