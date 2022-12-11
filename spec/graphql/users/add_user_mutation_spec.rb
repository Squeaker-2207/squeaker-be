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

  describe 'increase test coverage' do
    let(:mutation) { Mutations::AddUser.new(object: nil, field: nil, context: {}) }
    let(:user) { create(:user, id: 1) }

    it '::type_error' do
      result = SqueakrBeSchema.type_error(mutation.field, mutation.context)

      expect(result).to be_nil
    end

    it '::id_from_object' do
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

      result = SqueakrBeSchema.id_from_object(user, :addUser, query)

      expect(result).to be_a String
    end

    it '::object_from_id' do
      query = <<~GQL
        query {
          id: 1
        }
      GQL

      result = SqueakrBeSchema.object_from_id(user.id, query)

      expect(result).to be_nil
    end

    it '::resolve_type' do
      resolution = mutation.resolve(params: {
          username: 'new_username'
        })

      expect{SqueakrBeSchema.resolve_type(resolution, user, mutation.context)}.to raise_error(GraphQL::RequiredImplementationMissingError)
    end
  end
end
