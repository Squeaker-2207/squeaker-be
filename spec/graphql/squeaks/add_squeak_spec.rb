require 'rails_helper'

RSpec.describe 'Add Squeaks', :vcr do
  let(:user) { create(:user) }
  let(:content) { "Birds are a fiction created by Big Bird Seed" }

  it 'Can add squeaks to user' do
    query = <<~GQL
      mutation {
        addSqueak(input: { params: { content: "#{content}", userId: #{user.id} } }) {
          squeak {
            id
            content
            user {
              id
              username
            }
          }
        }
      }
    GQL

    result = SqueakrBeSchema.execute(query)

    expect(result.dig("data")).to be_a(Hash)
    expect(result.dig("data", "addSqueak")).to be_a(Hash)
    expect(result.dig("data", "addSqueak", "squeak")).to be_a(Hash)
    expect(result.dig("data", "addSqueak", "squeak", "id")).to be_a(String)
    expect(result.dig("data", "addSqueak", "squeak", "content")).to be_a(String)
    expect(result.dig("data", "addSqueak", "squeak", "content")).to eq(content)
    expect(result.dig("data", "addSqueak", "squeak", "user")).to be_a(Hash)
    expect(result.dig("data", "addSqueak", "squeak", "user", "id")).to be_a(String)
    expect(result.dig("data", "addSqueak", "squeak", "user", "id")).to eq(user.id.to_s)
    expect(result.dig("data", "addSqueak", "squeak", "user", "username")).to eq(user.username)
  end

  it 'returns errors if user id is not found' do
    query = <<~GQL
      mutation {
        addSqueak(input: { params: { content: "#{content}", userId: 999 } }) {
          squeak {
            id
            content
            user {
              id
              username
            }
          }
        }
      }
    GQL

    result = SqueakrBeSchema.execute(query)

    expect(result.dig("errors", 0, "message")).to eq("Couldn't find User with 'id'=999")
  end

  it 'returns errors if attributes are invalid or missing' do
    query = <<~GQL
      mutation {
        addSqueak(input: { params: { unicorns: "Are Pretty", userId: "#{user.id}" } }) {
          squeak {
            id
            content
            user {
              id
              username
            }
          }
        }
      }
    GQL

    result = SqueakrBeSchema.execute(query)

    expect(result.dig("errors", 0, "message")).to eq("Argument 'content' on InputObject 'SqueakInput' is required. Expected type String!")
    expect(result.dig("errors", 1, "message")).to eq("InputObject 'SqueakInput' doesn't accept argument 'unicorns'")
  end
end
