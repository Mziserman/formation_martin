# frozen_string_literal: true

RSpec.describe ActiveAdmin::HandleAasmEvent do
  subject do
    ActiveAdmin::HandleAasmEvent.new.call(params: params, resource: resource)
  end
  let(:resource) do
    create :project, *traits, trait_params
  end
  let(:traits) { [] }
  let(:trait_params) { {} }

  context 'with empty params' do
    let(:params) do
      {}
    end
    it 'succeeds' do
      expect(subject.success?).to be true
    end
    it 'does not change output' do
      subject.success do |output|
        expect(output[:resource].aasm_state).to eq :draft
      end
    end
  end

  context 'with active admin params for start_publication' do
    let(:params) do
      {
        active_admin_requested_event: 'start_publication'
      }
    end
    let(:traits) do
      %i[
        with_thumbnail
        with_landscape
      ]
    end
    it 'succeeds' do
      expect(subject.success?).to be true
    end
    it 'does not change output' do
      subject.success do |output|
        expect(output[:resource].aasm_state).to eq :start_publication
      end
    end
  end

  context 'with active admin params for start_publication on invalid record' do
    let(:params) do
      {
        active_admin_requested_event: 'start_publication'
      }
    end
    let(:traits) do
      %i[]
    end
    it 'fails' do
      expect(subject.failure?).to be true
    end
    it 'does not change output' do
      subject.success do |output|
        expect(output[:resource].aasm_state).to eq :draft
      end
    end
  end
end
