FactoryBot.define do
  factory :user, class: User do
    username { Faker::Name.name }
    is_admin { false }
  end
end