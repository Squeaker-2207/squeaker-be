require 'rails_helper'

RSpec.describe 'Get One User by ID Query', vcr: { record: :new_episodes } do
  let(:user) { create(:user)}
  let(:squeaks) { create_list(:squeak, 5) }

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

  it '::object_from_id' do
    user_gid = User.find_by_id(user.id).to_global_id
    query = <<~GQL
      query {
        id: user.id
      }
    GQL

    result = SqueakrBeSchema.object_from_id(user_gid, query)

    expect(result).to be_a User
    expect(result.id).to eq(user.id)
    expect(result.username).to eq(user.username)
    expect(result.is_admin).to eq(user.is_admin)
  end

  it '::id_from_object' do
    query = <<~GQL
      query {
        fetchUser(id: "#{user.id}") {
          id
          username
          isAdmin
        }
      }
    GQL

    result = SqueakrBeSchema.id_from_object(user, :fetchUser, query)

    expect(result).to be_a String
  end

  it 'returns all squeaks' do
    query = <<~GQL
      query {
        fetchUser(id: "#{user.id}") {
          id
          username
          isAdmin
          allSqueaks {
            id
            content
            nuts
            reports
            approved
          }
        }
      }
    GQL

    result = SqueakrBeSchema.execute(query, context: { fetch_user: user, all_squeaks: squeaks })

    data = result.dig("data")

    expect(data["fetchUser"]).to be_a(Hash)
    expect(data["fetchUser"]["allSqueaks"]).to be_a(Array)
    data["fetchUser"]["allSqueaks"].each do |squeak|
      expect(squeak["id"]).to be_a(String)
      expect(squeak["content"]).to be_a(String)
      expect(squeak["nuts"]).to be_a(Integer)
      expect(squeak["reports"]).to be_a(Integer)
      expect(squeak["approved"]).to be_in([nil, true])
    end
  end
end
