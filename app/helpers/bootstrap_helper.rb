# frozen_string_literal: true

module BootstrapHelper
  def type_to_bootstrap(type)
    HashWithIndifferentAccess.new(
      info: 'info',
      notice: 'info',
      alert: 'danger',
      success: 'success'
    )[type] || 'info'
  end

  def state_to_bootstrap(status)
    HashWithIndifferentAccess.new(
      ongoing: 'primary',
      upcoming: 'secondary',
      success: 'success',
      failure: 'danger',
      draft: 'info'
    )[status] || 'info'
  end
end
