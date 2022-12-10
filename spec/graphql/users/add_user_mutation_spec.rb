require 'rails_helper'

RSpec.describe 'Add User Mutation' do
  it 'can add new user' do
    query = <<~GQL
      mutation {
        addUser(input: { params: { username: "Test_User", isAdmin: false } }) {
          user {
            id
            username
            isAdmin
          }
        }
      }
    GQL

    result = SqueakrBeSchema.execute(query)
    expect(result.dig("data")).to be_a(Hash)
    expect(result.dig("data", "addUser")).to be_a(Hash)
    expect(result.dig("data", "addUser", "user")).to be_a(Hash)
    expect(result.dig("data", "addUser", "user", "username")).to eq("Test_User")
    expect(result.dig("data", "addUser", "user", "isAdmin")).to eq(false)
  end

  it 'returns errors if user params are missing' do
    query = <<~GQL
    mutation {
      addUser(input: { params: { } }) {
        user {
          id
          username
          isAdmin
        }
      }
    }
  GQL

  result = SqueakrBeSchema.execute(query)

  expect(result.dig("errors")).to be_a(Array)
  expect(result.dig("errors", 0, "message")).to eq("Argument 'username' on InputObject 'UserInput' is required. Expected type String!")
  expect(result.dig("errors", 1, "message")).to eq("Argument 'isAdmin' on InputObject 'UserInput' is required. Expected type Boolean!")
  end

  it 'returns errors if user params are invalid' do
    query = <<~GQL
      mutation {
        addUser(input: { params: { username: 100, isAdmin: Incorrect } }) {
          user {
            id
            username
            isAdmin
          }
        }
      }
    GQL

    result = SqueakrBeSchema.execute(query)

    expect(result.dig("errors", 0, "message")).to eq("Argument 'username' on InputObject 'UserInput' has an invalid value (100). Expected type 'String!'.")
    expect(result.dig("errors", 1, "message")).to eq("Argument 'isAdmin' on InputObject 'UserInput' has an invalid value (Incorrect). Expected type 'Boolean!'.")
  end

  it 'returns errors if incorrect params are passed' do
    query = <<~GQL
      mutation {
        addUser(input: { params: { unicorns: "are not real", isAdmin: false } }) {
          user {
            id
            username
            isAdmin
          }
        }
      }
    GQL

    result = SqueakrBeSchema.execute(query)

    expect(result.dig("errors", 0, "message")).to eq("Argument 'username' on InputObject 'UserInput' is required. Expected type String!")
    expect(result.dig("errors", 1, "message")).to eq("InputObject 'UserInput' doesn't accept argument 'unicorns'")
  end

  it 'raises errors if invalid user params' do
    query = <<~GQL
      mutation {
        user: addUser(
        input: { params: { username: "", isAdmin: false } }) {
          user {
            username
            isAdmin
          }
        }
      }
    GQL

    result = SqueakrBeSchema.execute(query)

    expect(result.dig('data')).to eq({'user'=>nil})
    expect(result.dig('data', 0)).to be_nil
    expect(result.dig('errors', 0, 'message')).to eq("Username can't be blank")
  end
end
