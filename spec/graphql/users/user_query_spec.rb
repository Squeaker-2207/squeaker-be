require 'rails_helper'

RSpec.describe 'Get One User by ID Query' do
  let(:user) { create(:user)}
  let(:bad_user) { create(:user, username: nil )}

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

    expect(result.dig("data").to be_a(Hash))
    expect(result.dig("data", "fetchUser")).to be_a(Hash)
    expect(result.dig("data", "fetchUser", "id")).to be_a(String)
    expect(result.dig("data, fetchUser", "id")).to eq("#{user.id}")
  end
end