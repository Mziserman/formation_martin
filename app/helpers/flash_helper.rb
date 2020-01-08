# frozen_string_literal: true

def type_to_bootstrap(type)
  HashWithIndifferentAccess.new(
    info: 'info',
    notice: 'info',
    alert: 'danger'
  )[type] || 'info'
end
