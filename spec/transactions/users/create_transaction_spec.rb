# frozen_string_literal: true

RSpec.describe Users::CreateTransaction do
  subject do
    Users::CreateTransaction.new.call(sign_up_params: attributes)
  end
  context 'with valid attributes' do
    let(:attributes) { attributes_for(:user) }
    let(:mail) { ActionMailer::Base.deliveries.last }
    let(:user) { subject.success }

    it 'succeeds' do
      expect(subject.success?).to be true
    end

    it 'creates a user with the attributes' do
      attributes.each do |method, value|
        expect(user.send(method)).to eql value
      end
    end

    it 'sends a welcome mail' do
      expect { subject }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end

    it 'renders the subject' do
      subject
      expect(mail.subject).to eq('Welcome to My Awesome Site')
    end

    it 'renders the receiver email' do
      subject
      expect(mail.to).to eq([user.email])
    end

    it 'renders the sender email' do
      subject
      expect(mail.from).to eq(['martin@capsens.eu'])
    end

    it 'assigns @name' do
      subject
      expect(mail.body.encoded).to match(user.first_name)
    end

    it 'assigns @confirmation_url' do
      subject
      expect(mail.body.encoded)
        .to match('/users/sign_in')
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
