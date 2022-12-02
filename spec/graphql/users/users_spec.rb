require 'rails_helper'

RSpec.describe 'Users Query' do
  let(:users) { create_list(:user, 5) }

  it 'returns a list of users' do
    query = <<~GQL
      query {
        fetchUsers {
          id
          username
          isAdmin
        }
      }
    GQL

    result = SqueakrBeSchema.execute(query, context: { fetch_users: users })

    expect(result.dig("data")).to be_a(Hash)
    expect(result.dig("data", "fetchUsers")).to be_a(Array)

    result.dig("data", "fetchUsers").each do |user|
      expect(user["id"]).to be_a(String)
      expect(user["username"]).to be_a(String)
      expect(user["isAdmin"]).to be_in([true, false])
    end
  end
end