FactoryBot.define do
  factory :coupon do
    association :brand
    value 1.0
  end
end
