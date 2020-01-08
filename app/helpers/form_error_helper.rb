# frozen_string_literal: true

module FormErrorHelper
  def error_class_if_needed(resource, field)
    'is-invalid' if resource.errors&.key?(field)
  end

  def errors_for_field(resource, field)
    if resource.errors&.key?(field)
      "<div class='invalid-feedback'>#{resource.errors[field].join(', ')}</div>".html_safe
    end
  end
end
