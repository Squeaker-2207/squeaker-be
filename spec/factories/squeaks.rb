FactoryBot.define do
  factory :squeak do
    content { Faker::Lorem.sentence }
    reports { Faker::Number.between(from: 0, to: 2) }
    nuts { Faker::Number.between(from: 0, to: 5) }
    approved { true }
    user { create(:user) }
    created_at { Time.zone.now }
    updated_at { Time.zone.now }
  end
end
