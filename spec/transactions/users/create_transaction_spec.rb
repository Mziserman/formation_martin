# frozen_string_literal: true

RSpec.describe Users::CreateTransaction do
  subject do
    Users::CreateTransaction.new.call(sign_up_params: attributes)
  end
  context 'with valid attributes' do
    let(:attributes) { attributes_for(:user) }

    it 'succeeds' do
      expect(subject.success?).to be true
    end

    it 'creates a user with the attributes' do
      user = subject.success
      attributes.each do |method, value|
        expect(user.send(method)).to eql value
      end
    end

    it 'sends a welcome mail' do
      expect { subject }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end
  end

  context 'without first_name' do
    let(:attributes) { attributes_for(:user).except(:first_name) }


    it 'fails' do
      expect(subject.failure?).to be true
    end

    it 'does not send a mail' do
      expect { subject }.to change { ActionMailer::Base.deliveries.count }.by(0)
    end
  end

  context 'without last_name' do
    let(:attributes) { attributes_for(:user).except(:last_name) }

    it 'fails' do
      expect(subject.failure?).to be true
    end

    it 'does not send a mail' do
      expect { subject }.to change { ActionMailer::Base.deliveries.count }.by(0)
    end
  end

  context 'without first_name' do
    let(:attributes) { attributes_for(:user).except(:first_name) }

    it 'fails' do
      expect(subject.failure?).to be true
    end

    it 'does not send a mail' do
      expect { subject }.to change { ActionMailer::Base.deliveries.count }.by(0)
    end
  end

  context 'without email' do
    let(:attributes) { attributes_for(:user).except(:email) }

    it 'fails' do
      expect(subject.failure?).to be true
    end

    it 'does not send a mail' do
      expect { subject }.to change { ActionMailer::Base.deliveries.count }.by(0)
    end
  end

  context 'without password' do
    let(:attributes) { attributes_for(:user).except(:password) }

    it 'fails' do
      expect(subject.failure?).to be true
    end

    it 'does not send a mail' do
      expect { subject }.to change { ActionMailer::Base.deliveries.count }.by(0)
    end
  end

  context 'with different password confirmation' do
    let(:attributes) do
      attributes_for(:user).tap do |user|
        user[:password_confirmation] = user[:password] + 'en_fait_non'
      end
    end

    it 'fails' do
      expect(subject.failure?).to be true
    end

    it 'does not send a mail' do
      expect { subject }.to change { ActionMailer::Base.deliveries.count }.by(0)
    end
  end
end
