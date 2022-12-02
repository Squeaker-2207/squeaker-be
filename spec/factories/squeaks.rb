FactoryBot.define do
  factory :squeak do
    content { Faker::Lorem.sentence(5) }
    reports { 0 }
    nuts { 0 }
    approved { false }
    user_id { 1 }
    created_at { Time.zone.now }
    updated_at { Time.zone.now }
  end
end
