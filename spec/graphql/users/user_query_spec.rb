require 'rails_helper'

RSpec.describe 'Get One User by ID Query' do
  let(:user) { create(:user)}

  it 'returns user by id' do
    query = <<~GQL
      query {
        fetchUser(id: "#{user.id}") {
          id
          username
          isAdmin
        }
      }
    GQL

    result = SqueakrBeSchema.execute(query, context: { fetch_user: user })

    expect(result.dig("data")).to be_a(Hash)
    expect(result.dig("data", "fetchUser")).to be_a(Hash)
    expect(result.dig("data", "fetchUser", "id")).to be_a(String)
    expect(result.dig("data", "fetchUser", "id")).to eq("#{user.id}")
    expect(result.dig("data", "fetchUser", "username")).to eq("#{user.username}")
    expect(result.dig("data", "fetchUser", "isAdmin")).to eq(user.is_admin)
  end

  it 'returns error if user id is not found' do
    query = <<~GQL
      query {
        fetchUser(id: "999") {
          id
          username
          isAdmin
        }
      }
    GQL

    result = SqueakrBeSchema.execute(query)

    expect(result.dig("data")).to eq(nil)
    expect(result.dig("errors")).to be_a(Array)
    expect(result.dig("errors", 0, "message")).to eq("User with id 999 not found.")
  end

  it 'returns errors if invalid attributes are passed' do
    query = <<~GQL
      query {
        fetchUser(id: "#{user.id}") {
          id
          username
          unicorn
        }
      }
    GQL

    result = SqueakrBeSchema.execute(query)

    expect(result.dig("errors")).to be_a(Array)
    expect(result.dig("errors", 0, "message")).to be_a(String)
    expect(result.dig("errors", 0, "message")).to eq("Field 'unicorn' doesn't exist on type 'User'")
  end
end