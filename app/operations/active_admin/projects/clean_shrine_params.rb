# frozen_string_literal: true

require 'dry/transaction/operation'

class ActiveAdmin::Projects::CleanShrineParams
  include Dry::Transaction::Operation

  def call(input)
    if input[:params][:thumbnail_data].blank?
      input[:params][:thumbnail_data] = nil
    end
    if input[:params][:landscape_data].blank?
      input[:params][:landscape_data] = nil
    end

    Success(input)
  end
end
