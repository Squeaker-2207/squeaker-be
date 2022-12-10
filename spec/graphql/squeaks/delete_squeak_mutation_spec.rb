require 'rails_helper'

RSpec.describe 'Delete Squeak Mutation', :vcr do
  it 'delete a squeak' do
    user = create(:user)
    squeak = create(:squeak, id: 1, user: user)
    query = <<~GQL
    mutation {
      deleteSqueak(input: { id: 1 }) {
        squeak {
          id
          content
        }
      }
    }
    GQL

    result = SqueakrBeSchema.execute(query)
    expect(result.dig("data")).to be_a(Hash)
    expect(result.dig("data", "deleteSqueak")).to be_a(Hash)
    expect(result.dig("data", "deleteSqueak", "squeak")).to be_a(Hash)
    expect(result.dig("data", "deleteSqueak", "squeak", 'id')).to be_a(String)
  end

  it 'returns an error if the squeak does not exist' do
    query = <<~GQL
    mutation {
      deleteSqueak(input: {id: 7 }) {
        squeak {
          id
          content
        }
      }
    }
    GQL

    result = SqueakrBeSchema.execute(query)
    expect(result.dig("errors")).to be_a(Array)
    expect(result.dig("errors", 0, "message")).to eq("Couldn't find Squeak with 'id'=7")
  end

  it 'returns errors if id argument is missing' do
    query = <<~GQL
    mutation {
      deleteSqueak(input: { }) {
        squeak {
          id
          content
        }
      }
    }
    GQL

    result = SqueakrBeSchema.execute(query)

    expect(result.dig("errors")).to be_a(Array)
    expect(result.dig("errors", 0, "message")).to eq("Argument 'id' on InputObject 'DeleteSqueakInput' is required. Expected type ID!")
  end

  it 'returns errors if id param is invalid' do
    query = <<~GQL
    mutation {
      deleteSqueak(input: {id: false }) {
        squeak {
          id
          content
        }
      }
    }
    GQL

    result = SqueakrBeSchema.execute(query)

    expect(result.dig("errors", 0, "message")).to eq("Argument 'id' on InputObject 'DeleteSqueakInput' has an invalid value (false). Expected type 'ID!'.")
  end
end
