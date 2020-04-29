# frozen_string_literal: true

every 1.day, at: '2:00 am' do
  rake 'mangopay:renew_processing_bank_wire_payment_status'
end
