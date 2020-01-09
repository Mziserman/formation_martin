# frozen_string_literal: true

module FormErrorHelper
  def error_class_if_needed(resource, field)
    resource.errors&.key?(field) ? 'is-invalid' : ''
  end

  def errors_for_field(resource, field)
    if resource.errors&.key?(field)
      "<div class='invalid-feedback'>#{resource.errors[field].join(', ')}</div>".html_safe
    end
  end

  def classes_for_field(resource, field)
    ['form-control', error_class_if_needed(resource, field)].reject(&:blank?).join(' ')
  end
end
