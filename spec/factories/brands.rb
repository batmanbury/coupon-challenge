FactoryBot.define do
  factory :brand do
    sequence(:name) { |n| "Acme Corp #{n}" }
  end
end
