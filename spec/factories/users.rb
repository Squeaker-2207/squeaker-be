FactoryBot.define do
  factory :user do
    username { Faker::Internet.username }
    is_admin { false }
  end
end
