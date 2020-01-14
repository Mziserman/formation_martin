# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Project, type: :model do
  subject { create :project, *traits, params }
  let(:params) { {} }
  let(:traits) { [] }

  it { should have_many(:project_ownerships) }
  it { should have_many(:owners).class_name('User') }
  it { should have_many(:rewards) }
  it { should have_many(:contributions) }
  it { should have_many(:contributors).class_name('User').source(:user) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:amount_wanted_in_cents) }

  context 'with one contribution' do
    let(:traits) { [:with_contributions] }
    let(:params) do
      {
        contributions: [
          {
            amount_donated_in_cents: 100_000,
            user: create(:user)
          }
        ]
      }
    end
    it 'total collected is 100 000 cents' do
      expect(subject.total_collected).to eq 100_000
    end
    it 'min and max contributor are the same' do
      expect(subject.max_contributor).to eq subject.min_contributor
    end
  end

  context 'with three contributions' do
    let(:traits) { [:with_contributions] }
    let(:params) do
      {
        contributions: [
          {
            amount_donated_in_cents: 100_000,
            user: create(:user)
          },
          {
            amount_donated_in_cents: 200_000,
            user: create(:user)
          },
          {
            amount_donated_in_cents: 300_000,
            user: create(:user)
          }
        ]
      }
    end

    it 'total collected is 600 000 cents' do
      expect(subject.total_collected).to eq 600_000
    end

    it 'min and max contributor are the same' do
      expect(subject.max_contributor).to_not eq subject.min_contributor
    end

    it 'min contribution is 100 000 cents' do
      expect(subject.min_contribution.amount_donated_in_cents).to eq 100_000
    end

    it 'max contribution is 300 000 cents' do
      expect(subject.max_contribution.amount_donated_in_cents).to eq 300_000
    end

    it 'completion make sense' do
      expect(subject.completion).to eq(
        subject.contributions.sum(:amount_donated_in_cents) / subject.amount_wanted_in_cents.to_f
      )
    end
  end
end
