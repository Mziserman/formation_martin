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
  it { should validate_presence_of(:amount_wanted) }

  it 'can\'t start publication' do
    expect { subject.start_publication }.to raise_error AASM::InvalidTransition
  end

  context 'with valid start publication attributes' do
    let(:params) { {} }
    let(:traits) { %i[with_thumbnail with_landscape] }

    it 'can start publication' do
      expect { subject.start_publication }.to_not raise_error
    end

    it 'can\'t finish publication' do
      expect { subject.finish_publication }.to raise_error AASM::InvalidTransition
    end
  end

  context 'with valid start and finish publication attributes' do
    let(:params) { {} }
    let(:traits) do
      %i[
        with_thumbnail
        with_landscape
        with_rewards
        with_categories
      ]
    end

    it 'can start publication' do
      expect { subject.start_publication }.to_not raise_error
    end

    it 'can finish publication' do
      expect do
        subject.start_publication
        subject.finish_publication
      end.to_not raise_error
    end

    it 'can fail' do
      expect do
        subject.start_publication
        subject.finish_publication
        subject.fail
      end.to_not raise_error
    end

    it 'can\'t succeed :/' do
      expect do
        subject.start_publication
        subject.finish_publication
        subject.succeed
      end.to raise_error AASM::InvalidTransition
    end
  end

  context 'with valid start and finish publication attributes and completed' do
    let(:params) do
      {
        contributions: [
          {
            amount: 999_999_999,
            user: create(:user)
          }
        ]
      }
    end
    let(:traits) do
      %i[
        with_thumbnail
        with_landscape
        with_rewards
        with_categories
        with_contributions
      ]
    end

    it 'can start publication' do
      expect { subject.start_publication }.to_not raise_error
    end

    it 'can finish publication' do
      expect do
        subject.start_publication
        subject.finish_publication
      end.to_not raise_error
    end

    it 'can\'t fail' do
      expect do
        subject.start_publication
        subject.finish_publication
        subject.fail
      end.to raise_error AASM::InvalidTransition
    end

    it 'can succeed' do
      expect do
        subject.start_publication
        subject.finish_publication
        subject.succeed
      end.to_not raise_error
    end
  end

  context 'with one contribution' do
    let(:traits) { [:with_contributions] }
    let(:params) do
      {
        contributions: [
          {
            amount: 100_000,
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
            amount: 100_000,
            user: create(:user)
          },
          {
            amount: 200_000,
            user: create(:user)
          },
          {
            amount: 300_000,
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
      expect(subject.min_contribution.amount).to eq 100_000
    end

    it 'max contribution is 300 000 cents' do
      expect(subject.max_contribution.amount).to eq 300_000
    end

    it 'completion is (sum of contributions / amount wanted)' do
      expect(subject.completion).to eq(
        (subject.contributions.sum(:amount) / subject.amount_wanted.to_f).round(2)
      )
    end
  end

  context 'with three contributions from the same user' do
    let(:traits) { [:with_contributions] }
    let(:user) { create :user }
    let(:params) do
      {
        contributions: [
          {
            amount: 100_000,
            user: user
          },
          {
            amount: 200_000,
            user: user
          },
          {
            amount: 300_000,
            user: user
          }
        ]
      }
    end

    it 'total collected is 600 000 cents' do
      expect(subject.total_collected).to eq 600_000
    end

    it 'min and max contributor are the same' do
      expect(subject.max_contributor).to eq subject.min_contributor
    end

    it 'min contribution is 100 000 cents' do
      expect(subject.min_contribution.amount).to eq 100_000
    end

    it 'max contribution is 300 000 cents' do
      expect(subject.max_contribution.amount).to eq 300_000
    end

    it 'amount donated from user is the sum of its donations' do
      expect(subject.amount_contributed_from(user)).to eq 600_000
    end
  end

  context 'with a big and a small donor' do
    let(:traits) { [:with_contributions] }
    let(:big_donor) { create :user }
    let(:small_donor) { create :user }
    let(:params) do
      {
        contributions: [
          {
            amount: 100_000,
            user: big_donor
          },
          {
            amount: 200_000,
            user: big_donor
          },
          {
            amount: 300_000,
            user: big_donor
          },
          {
            amount: 100,
            user: small_donor
          },
          {
            amount: 200,
            user: small_donor
          },
          {
            amount: 300,
            user: small_donor
          }
        ]
      }
    end

    it 'total collected is 600 000 cents' do
      expect(subject.total_collected).to eq 600_600
    end

    it 'min and max contributor are not the same' do
      expect(subject.max_contributor).to_not eq subject.min_contributor
    end

    it 'max contributor is big_donor' do
      expect(subject.max_contributor).to eq big_donor
    end

    it 'min contributor is small_donor' do
      expect(subject.min_contributor).to eq small_donor
    end

    it 'min contribution is 100 cents' do
      expect(subject.min_contribution.amount).to eq 100
    end

    it 'max contribution is 300 000 cents' do
      expect(subject.max_contribution.amount).to eq 300_000
    end

    it 'amount contributed from big donor is 600 000' do
      expect(subject.amount_contributed_from(big_donor)).to eq 600_000
    end

    it 'amount contributed from small donor is 600' do
      expect(subject.amount_contributed_from(small_donor)).to eq 600
    end
  end
end
