RSpec.describe FactoryBot do
  context 'Each factories' do
    it 'creates instances without raising' do
      expect { FactoryBot.lint(traits: true) }.not_to raise_error
    end
  end
end
