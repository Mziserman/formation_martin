FactoryBot.define do
  factory :contribution do
    amount { rand(100..100_000_000) }

    project
    user
    reward

    before(:create) do |contribution|
      contribution.project = create :project unless contribution.project.nil?
      contribution.user = create :user unless contribution.user.nil?
    end
  end
end
