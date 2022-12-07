require 'rails_helper'

RSpec.describe 'User squeaks' do
  before :each do
    @user = create(:user)
    @user_no_squeaks = create(:user)
    @squeaks = create_list(:squeak, 10, user: @user)
  end

  it 'Returns squeaks associated with a user' do
    query = <<~GQL
      query {
        fetchUser(id: "#{@user.id}") {
          id
          username
          isAdmin
          userSqueaks {
            id
            content
            userId
            nuts
            reports
          }
        }
      }
    GQL

    result = SqueakrBeSchema.execute(query, context: { fetch_user: @user })

    expect(result.dig("data")).to be_a(Hash)
    expect(result.dig("data", "fetchUser")).to be_a(Hash)
    expect(result.dig("data", "fetchUser", "userSqueaks")).to be_a(Array)
    result.dig("data", "fetchUser", "userSqueaks").each do |squeak|
      expect(squeak["id"]).to be_a(String)
      expect(squeak["content"]).to be_a(String)
      expect(squeak["userId"]).to be_a(Integer)
      expect(squeak["nuts"]).to be_a(Integer)
      expect(squeak["reports"]).to be_a(Integer)
    end
  end

  it 'returns empty array if user has no squeaks' do
    query = <<~GQL
      query {
        fetchUser(id: "#{@user_no_squeaks.id}") {
          id
          username
          isAdmin
          userSqueaks {
            id
            content
            userId
            nuts
            reports
          }
        }
      }
    GQL

    result = SqueakrBeSchema.execute(query, context: { fetch_user: @user })

    expect(result.dig("data", "fetchUser", "userSqueaks")).to be_a(Array)
    expect(result.dig("data", "fetchUser", "userSqueaks")).to eq([])
  end
end