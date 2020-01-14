# frozen_string_literal: true

module PrinterHelper
  def currency_print(cents = 0)
    number_to_currency(cents.to_f / 100, delimiter: ' ')
  end

  def percent_print(ratio)
    number_to_percentage(ratio * 100, delimiter: ' ', precision: 2)
  end
end
