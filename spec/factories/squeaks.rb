FactoryBot.define do
  factory :squeak do
    content { Faker::Lorem.sentence }
    reports { 0 }
    nuts { 0 }
    approved { false }
    user_id { Faker::Number.between(from: 1, to: 10) }
    created_at { Time.zone.now }
    updated_at { Time.zone.now }
  end
end
