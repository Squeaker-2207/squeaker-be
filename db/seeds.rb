# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

5.times do |i|
  User.create(username: "User #{i + 1}", is_admin: false)
end

20.times do |i|
  Squeak.create(content: "This is squeak ##{i}", user_id: Faker::Number.between(from: 1, to: 10))
end
