# frozen_string_literal: true

module ActiveAdminControllerHelpers
  def active_admin_date_format(date)
    I18n.l(date, format: '%A %d %B %Y %Hh%M').downcase
  end
end
