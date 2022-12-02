FactoryBot.define do
  factory :relationship do
    follower_id { 2 }
    followed_id { 1 }
  end
end
