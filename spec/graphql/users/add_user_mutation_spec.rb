require 'rails_helper'

RSpec.describe 'Add User Mutation' do
  it 'can add new user' do
    user_params = { username: "Test_User", is_admin: false }

    mutation = <<~GQL
      mutation {
        addUser(input: { params: user_params }) {
          user {
            id
            username
            isAdmin
          }
        }
      }
    GQL

    result = SqueakrBeSchema.execute(mutation, context: { add_users: user_params })
    require 'pry'; binding.pry
  end
end