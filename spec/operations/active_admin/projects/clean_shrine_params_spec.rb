# frozen_string_literal: true

RSpec.describe ActiveAdmin::Projects::CleanShrineParams do
  subject do
    ActiveAdmin::Projects::CleanShrineParams.new.call(params: params)
  end
  context 'with empty params' do
    let(:params) { {} }
    it 'succeeds' do
      expect(subject.success?).to be true
    end
    it 'does not create the keys' do
      subject.success do |output|
        expect(output[:params]).to eq params
      end
    end
  end

  context 'with blank params' do
    let(:params) do
      {
        thumbnail_data: '',
        landscape_data: ''
      }
    end
    it 'succeeds' do
      expect(subject.success?).to be true
    end
    it 'does not create the keys' do
      subject.success do |output|
        expect(output[:params]).to eq(
          thumbnail_data: nil,
          landscape_data: nil
        )
      end
    end
  end
  context 'with actual params' do
    let(:params) do
      {
        thumbnail_data: 'oui',
        landscape_data: 'non'
      }
    end
    it 'succeeds' do
      expect(subject.success?).to be true
    end
    it 'does not create the keys' do
      subject.success do |output|
        expect(output[:params]).to eq params
      end
    end
  end
end
