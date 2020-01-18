# frozen_string_literal: true

RSpec.describe ActiveAdmin::SetParams do
  subject do
    ActiveAdmin::SetParams.new.call(params: params, param_key: param_key)
  end
  context 'with empty params' do
    let(:params) { {} }
    let(:param_key) {}
    it 'succeeds' do
      expect(subject.success?).to be true
    end
    it 'does not change output' do
      subject.success do |output|
        expect(output[:params]).to eq params
      end
    end
  end

  context 'with active admin params' do
    let(:params) do
      {
        project: {
          project_param: 'project value'
        }
      }
    end
    let(:param_key) do
      :project
    end
    it 'succeeds' do
      expect(subject.success?).to be true
    end
    it 'does not change output' do
      subject.success do |output|
        expect(output[:params]).to eq params[param_key]
      end
    end
  end
end
