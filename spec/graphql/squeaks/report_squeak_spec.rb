require 'rails_helper'

RSpec.describe 'Update Squeak Mutation' do
  it 'update a squeak by adding a report' do
    user = create(:user)
    squeak = create(:squeak, id: 1, user: user)
    query = <<~GQL
    mutation {
      updateSqueak(input: { id: 1, report: true }) {
        squeak {
          id
          content
          score{
            metric
            probability
          }
        }
      }
    }
    GQL

    result = SqueakrBeSchema.execute(query)
    expect(result.dig("data")).to be_a(Hash)
    # expect(result.dig("data", "deleteSqueak", "squeak")).to be_a(Hash)
    # expect(result.dig("data", "deleteSqueak", "squeak", 'id')).to be_a(String)
  end
end
