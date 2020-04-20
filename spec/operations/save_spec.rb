# frozen_string_literal: true

RSpec.describe Save do
  subject do
    resource.assign_attributes(params)
    Save.new.call(resource: resource)
  end

  context 'with valid params' do
    let(:params) { attributes_for(:project) }
    let(:resource) { create :project }

    it 'succeeds' do
      expect(subject.success?).to be true
    end
    it 'updates the project' do
      params.stringify_keys!
      keys = params.keys
      previous = resource.attributes.filter do |k, _|
        keys.include?(k)
      end

      expect { subject }.to change {
        resource.attributes.filter do |k, _|
          keys.include?(k)
        end
      }.from(previous).to(params)
    end
  end
end
