RSpec.describe Create do
  subject do
    Create.new.call(params: params, model: model)
  end

  context 'with valid params' do
    let(:params) { attributes_for(:project) }
    let(:model) { Project }

    it 'succeeds' do
      expect(subject.success?).to be true
    end
    it 'creates a project' do
      subject.success do |output|
        expect(output[:record].class).to eq Project
        expect(output[:record].persisted?).to be true
      end
    end
    it 'creates a project with the right attributes' do
      subject.success do |output|
        attributes.each do |key, value|
          expect(output[:record].send(key)).to eq value
        end
      end
    end
  end
end
