# frozen_string_literal: true

namespace :mangopay do
  task renew_processing_bank_wire_payment_status: :environment do
    Contribution.processing.bank_wire.where('created_at < ?', 10.minutes.ago).each do |contribution|
      Contributions::ValidateTransaction.new.call(resource: contribution)
    end
  end
end
