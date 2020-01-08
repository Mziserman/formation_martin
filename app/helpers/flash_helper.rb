# frozen_string_literal: true

module FlashHelper
  def type_to_bootstrap(type)
    HashWithIndifferentAccess.new(
      info: 'info',
      notice: 'info',
      alert: 'danger'
    )[type] || 'info'
  end
end
