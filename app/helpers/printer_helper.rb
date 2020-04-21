# frozen_string_literal: true

module PrinterHelper
  def currency_print(cents = 0)
    number_to_currency(cents.to_f / 100, delimiter: ' ')
  end

  def percent_print(ratio)
    number_to_percentage(ratio * 100, delimiter: ' ', precision: 2)
  end

  def aasm_state_choice
    if current_admin_user.present?
      [['Brouillon', :draft], ['Prévu', :upcoming], ['En cours', :ongoing],
       ['Terminé', :success], ['Remboursé', :failure]]
    else
      [['En cours', :ongoing], ['Terminé', :success], ['Remboursé', :failure]]
    end
  end
end
