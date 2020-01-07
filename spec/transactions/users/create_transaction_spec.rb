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

  end
end
