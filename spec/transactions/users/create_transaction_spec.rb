# frozen_string_literal: true

RSpec.describe Users::CreateTransaction do
  context 'with valid attributes' do
    let(:attributes) { attributes_for(:user) }
    let(:transaction) do
      Users::CreateTransaction.new.call(sign_up_params: attributes)
    end

    it 'succeeds' do
      expect(transaction.success?).to be true
    end

    it 'creates a user with the attributes' do
      user = transaction.success
      attributes.each do |method, value|
        expect(user.send(method)).to eql value
      end
    end

    it 'sends a welcome mail' do
      expect { t = transaction }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end
  end

  context 'with invalid attributes' do
    let(:attributes_without_first_name) { attributes_for(:user).except(:first_name) }
    let(:attributes_without_last_name) { attributes_for(:user).except(:last_name) }
    let(:attributes_without_email) { attributes_for(:user).except(:email) }
    let(:attributes_without_password) { attributes_for(:user).except(:password) }
    let(:attributes_with_different_password_confirmation) do
      attributes_for(:user).tap do |user|
        user[:password_confirmation] = user[:password] + 'en_fait_non'
      end
    end
    let(:transaction_without_first_name) do
      Users::CreateTransaction.new.call(attributes_without_first_name)
    end

    let(:transaction_without_last_name) do
      Users::CreateTransaction.new.call(attributes_without_last_name)
    end

    let(:transaction_without_email) do
      Users::CreateTransaction.new.call(attributes_without_email)
    end

    let(:transaction_without_password) do
      Users::CreateTransaction.new.call(attributes_without_password)
    end

    let(:transaction_with_different_password_confirmation) do
      Users::CreateTransaction.new.call(attributes_with_different_password_confirmation)
    end

    let(:transactions) do
      [
        transaction_without_first_name,
        transaction_without_last_name,
        transaction_without_email,
        transaction_without_password,
        transaction_with_different_password_confirmation
      ]
    end

    it 'fails' do
      expect(transactions.all?(&:failure?)).to be true
    end

    it 'does not send a mail' do
      transactions.each do |transaction|
        expect { t = transaction }.to change { ActionMailer::Base.deliveries.count }.by(0)
      end
    end
  end
end
